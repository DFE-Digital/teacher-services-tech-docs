require "json"

module SchoolsDigitalTechDocs
  module GitHub
    module Ruby
      module Dependencies
        class CompilationBase
          def initialize(service_name:, lockfile:, package_json_file:, yarn_lock_file:, gemfile_file: nil, production_environment_file: nil)
            @service_name = service_name
            @lockfile = lockfile
            @package_json_file = package_json_file
            @yarn_lock_file = yarn_lock_file
            @gemfile_file = gemfile_file
            @production_environment_file = production_environment_file
          end

        private

          def get_dependency_version(dep)
            parsed_lockfile&.specs&.find { |s| s.name == dep }&.version&.to_s
          end

          def package_dependency_version(dep)
            parsed_package_json&.dig("dependencies", dep) || parsed_package_json&.dig("devDependencies", dep)
          end

          def js_dependency_version(dep)
            yarn_lock_version(dep) || package_dependency_version(dep)
          end

          def yarn_lock_version(dep)
            return unless @yarn_lock_file.present?

            requested_version = package_dependency_version(dep)
            entries = parsed_yarn_lock_entries.fetch(dep, [])
            return if entries.empty?

            if requested_version.present?
              preferred = entries.find do |entry|
                entry[:selectors].any? { |selector| selector_matches_request?(dep, requested_version, selector) }
              end
              return preferred[:version] if preferred
            end

            entries.first[:version]
          end

          def selector_matches_request?(dep, requested_version, selector)
            selector == "#{dep}@#{requested_version}" || selector == "#{dep}@npm:#{requested_version}"
          end

          def parsed_yarn_lock_entries
            @parsed_yarn_lock_entries ||= begin
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

          def parsed_package_json
            return unless @package_json_file.present?

            @parsed_package_json ||= JSON.parse(@package_json_file)
          rescue JSON::ParserError => e
            raise "Invalid package.json in #{@service_name}: #{e.message}"
          end

          def parsed_lockfile
            return unless @lockfile

            @parsed_lockfile ||= Bundler::LockfileParser.new(@lockfile)
          end

          def gem_declared?(gem_name)
            gemfile_file_content&.match?(/gem\s+["']#{Regexp.escape(gem_name)}["']/)
          end

          def gemfile_file_content
            @gemfile_file
          end

          def production_environment_file_content
            @production_environment_file
          end
        end
      end
    end
  end
end
