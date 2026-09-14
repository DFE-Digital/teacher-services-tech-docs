module SchoolsDigitalTechDocs
  module GitHub
    module Ruby
      module Dependencies
        class YarnLockEntries
          def initialize(yarn_lock_file)
            @yarn_lock_file = yarn_lock_file
          end

          def version_for(dep, requested_version: nil)
            return unless @yarn_lock_file.present?

            entries = parsed_entries.fetch(dep, [])
            return if entries.empty?

            if requested_version.present?
              preferred = entries.find do |entry|
                entry[:selectors].any? { |selector| selector_matches_request?(dep, requested_version, selector) }
              end
              return preferred[:version] if preferred
            end

            entries.first[:version]
          end

        private

          def selector_matches_request?(dep, requested_version, selector)
            ["#{dep}@#{requested_version}", "#{dep}@npm:#{requested_version}"].include?(selector)
          end

          def parsed_entries
            @parsed_entries ||= begin
              entries_by_package = Hash.new { |hash, key| hash[key] = [] }
              lines = @yarn_lock_file.split("\n")

              i = 0
              while i < lines.length
                line = lines[i]
                unless line =~ /\A\S.*:\z/
                  i += 1
                  next
                end

                selectors = line.chomp(":").split(",").map { |selector| selector.strip.delete_prefix("\"").delete_suffix("\"") }
                i += 1

                version = nil
                while i < lines.length && lines[i].start_with?(" ")
                  match = lines[i].match(/\A\s{2}version(?:\s|:)\s*"?(?<version>[^"\s]+)"?\z/)
                  version = match[:version] if match
                  i += 1
                end

                next unless version

                selectors.each do |selector|
                  package_name = package_name_from_selector(selector)
                  next unless package_name

                  entries_by_package[package_name] << { selectors:, version: }
                end
              end

              entries_by_package
            end
          end

          def package_name_from_selector(selector)
            if selector.start_with?("@")
              selector[/\A(@[^\/]+\/[^@]+)@/, 1]
            else
              selector[/\A([^@]+)@/, 1]
            end
          end
        end
      end
    end
  end
end
