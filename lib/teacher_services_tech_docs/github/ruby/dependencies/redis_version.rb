module SchoolsDigitalTechDocs
  module GitHub
    module Ruby
      module Dependencies
        class RedisVersion
          def initialize(terraform_files:)
            @files = TerraformFileSet.new(terraform_files)
          end

          def value
            has_redis, hardcoded_version, var_name = redis_modules
            has_redis, hardcoded_version, var_name = redis_tf_files unless has_redis

            return hardcoded_version if hardcoded_version
            return "None" unless has_redis

            (var_name && version_for_var(var_name)) || "Not pinned"
          end

        private

          def redis_modules
            has_redis = false
            hardcoded_version = nil
            var_name = nil

            @files.each_content do |content|
              TerraformBlockScanner.bodies(content, /module\s+"[^"]*redis[^"]*"\s*\{/).each do |module_body|
                has_redis = true

                version_match = module_body.match(/server_version\s*=\s*"(\d+[.\d]*)"/)
                if version_match
                  hardcoded_version = version_match[1]
                  break
                end

                var_match = module_body.match(/server_version\s*=\s*var\.(\w+)/)
                var_name ||= var_match[1] if var_match
              end

              break if hardcoded_version
            end

            [has_redis, hardcoded_version, var_name]
          end

          def redis_tf_files
            files = @files.files_ending_with("redis.tf")
            return [false, nil, nil] if files.empty?

            hardcoded_version = nil
            var_name = nil

            files.each_value do |content|
              version_match = content.match(/server_version\s*=\s*"(\d+[.\d]*)"/)
              if version_match
                hardcoded_version = version_match[1]
                break
              end

              var_match = content.match(/server_version\s*=\s*var\.(\w+)/)
              var_name ||= var_match[1] if var_match
            end

            [true, hardcoded_version, var_name]
          end

          def version_for_var(var_name)
            @files.production_tfvars_files.each_value do |content|
              version_match = content.match(/#{Regexp.escape(var_name)}["\s:=]*"?([\d.]+)"?/)
              return version_match[1] if version_match
            end

            @files.variable_files.each_value do |content|
              TerraformBlockScanner.bodies(content, /variable\s+"#{Regexp.escape(var_name)}"\s*\{/).each do |variable_body|
                default_match = variable_body.match(/default\s*=\s*"?([\d.]+)"?/)
                return default_match[1] if default_match
              end
            end

            nil
          end
        end
      end
    end
  end
end
