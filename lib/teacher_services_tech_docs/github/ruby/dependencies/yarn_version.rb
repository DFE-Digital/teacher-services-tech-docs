module SchoolsDigitalTechDocs
  module GitHub
    module Ruby
      module Dependencies
        class YarnVersion < DependencyDetectorBase
          def value
            package_manager = parsed_package_json&.dig("packageManager")
            package_manager_match = package_manager&.match(/\Ayarn@([^+\s]+)/)
            return package_manager_match[1] if package_manager_match

            tool_version_value = tool_version(["yarn"], label: "yarn")
            return tool_version_value if tool_version_value.present?
            return "4.x (yarnrc.yml present)" if @yarnrc_file.present?
          end
        end
      end
    end
  end
end
