require "json"

module SchoolsDigitalTechDocs
  module GitHub
    module Ruby
      module Dependencies
        class DependencyDetectorBase
          def initialize(
            service_name:,
            lockfile: nil,
            package_json_file: nil,
            yarn_lock_file: nil,
            production_environment_file: nil,
            dfe_analytics_initializer_file: nil,
            tool_versions_file: nil,
            ruby_version_file: nil,
            node_version_file: nil,
            nvmrc_file: nil,
            yarnrc_file: nil
          )
            @service_name = service_name
            @lockfile_lookup = LockfileLookup.new(lockfile)
            @package_json_file = package_json_file
            @yarn_lock_entries = YarnLockEntries.new(yarn_lock_file)
            @production_environment_file = production_environment_file
            @dfe_analytics_initializer_file = dfe_analytics_initializer_file
            @tool_versions_file = tool_versions_file
            @ruby_version_file = ruby_version_file
            @node_version_file = node_version_file
            @nvmrc_file = nvmrc_file
            @yarnrc_file = yarnrc_file
          end

        private

          def get_dependency_version(dep)
            @lockfile_lookup.version_of(dep)
          end

          def dependency_present?(gem_name)
            get_dependency_version(gem_name).present? || gem_declared?(gem_name)
          end

          def shakapacker_version
            js_dependency_version("shakapacker") || get_dependency_version("shakapacker")
          end

          def webpack_version
            js_dependency_version("webpack") || get_dependency_version("webpacker")
          end

          def package_dependency_version(dep)
            parsed_package_json&.dig("dependencies", dep) || parsed_package_json&.dig("devDependencies", dep)
          end

          def js_dependency_version(dep)
            yarn_lock_version(dep) || package_dependency_version(dep)
          end

          def yarn_lock_version(dep)
            @yarn_lock_entries.version_for(dep, requested_version: package_dependency_version(dep))
          end

          def parsed_package_json
            return unless @package_json_file.present?

            @parsed_package_json ||= JSON.parse(@package_json_file)
          rescue JSON::ParserError => e
            raise "Invalid package.json in #{@service_name}: #{e.message}"
          end

          def gem_declared?(gem_name)
            @lockfile_lookup.declared?(gem_name)
          end

          def production_environment_file_content
            @production_environment_file
          end

          def dfe_analytics_initializer_file_content
            @dfe_analytics_initializer_file
          end

          def version_from_file(file_contents)
            return unless file_contents.present?

            file_contents.split.last
          end

          def tool_version(tool_names, required: false, label: tool_names.join("/"))
            return unless @tool_versions_file.present?

            pattern = /\A(?:#{tool_names.join('|')})\s+\S+/
            matches = @tool_versions_file.split("\n").select { |line| line.match?(pattern) }

            if required && matches.empty?
              raise "Tool versions file in #{@service_name} has no #{label} entry #{@tool_versions_file}"
            end

            return if matches.empty?

            if matches.length > 1
              raise "Tool versions file in #{@service_name} has multiple #{label} entries #{matches}" if required

              return
            end

            matches.first.split.last
          end
        end
      end
    end
  end
end
