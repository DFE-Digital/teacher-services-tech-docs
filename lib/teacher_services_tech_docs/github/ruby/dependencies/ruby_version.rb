module SchoolsDigitalTechDocs
  module GitHub
    module Ruby
      module Dependencies
        class RubyVersion < DependencyDetectorBase
          def value
            version = if @lockfile_lookup.ruby_version_pin.present?
                        @lockfile_lookup.ruby_version_pin.gsub("ruby ", "")
                      elsif @ruby_version_file.present?
                        @ruby_version_file.split.last
                      elsif @tool_versions_file.present?
                        tool_version(%w[ruby], required: true, label: "Ruby")
                      end

            Gem::Version.new(version).release.to_s if version
          end
        end
      end
    end
  end
end
