module SchoolsDigitalTechDocs
  module GitHub
    module Ruby
      module Dependencies
        class NodeVersion < DependencyDetectorBase
          def value
            version = version_from_file(@node_version_file) ||
              version_from_file(@nvmrc_file) ||
              tool_version(%w[nodejs node], label: "nodejs/node") ||
              parsed_package_json&.dig("volta", "node") ||
              parsed_package_json&.dig("engines", "node")

            version&.delete_prefix("v")
          end
        end
      end
    end
  end
end
