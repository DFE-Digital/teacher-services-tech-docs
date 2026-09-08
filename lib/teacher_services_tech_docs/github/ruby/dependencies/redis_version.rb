module SchoolsDigitalTechDocs
  module GitHub
    module Ruby
      module Dependencies
        class RedisVersion
          TERRAFORM_DIRS = [
            "terraform/aks",
            "terraform/application",
            "terraform",
          ].freeze

          def initialize(terraform_files:)
            @terraform_files = terraform_files
          end

          def value
            TERRAFORM_DIRS.each do |terraform_dir|
              result = value_for(terraform_dir)
              return result if result
            end

            "None"
          end

        private

          def value_for(terraform_dir)
            files_in_dir = files_for(terraform_dir)
            return if files_in_dir.empty?

            has_redis, hardcoded_version, var_name = redis_modules(files_in_dir)

            unless has_redis
              has_redis, hardcoded_version, var_name = redis_tf_files(files_in_dir)
            end

            return hardcoded_version if hardcoded_version

            return unless has_redis

            var_name ? (version_for_var(files_in_dir, var_name) || "Not pinned") : "Not pinned"
          end

          def redis_modules(files_in_dir)
            has_redis = false
            hardcoded_version = nil
            var_name = nil

            files_in_dir.each_value do |content|
              content.scan(/module\s+"[^"]*redis[^"]*"\s*\{(.*?)^\}/m).each do |(module_body)|
                has_redis = true

                version_match = module_body.match(/server_version\s*=\s*"(\d+[.\d]*)"/)
                if version_match
                  hardcoded_version = version_match[1]
                  break
                end

                var_match = module_body.match(/server_version\s*=\s*var\.(\w+)/)
                var_name = var_match[1] if var_match
              end

              break if hardcoded_version
            end

            [has_redis, hardcoded_version, var_name]
          end

          def redis_tf_files(files_in_dir)
            redis_files = files_in_dir.select { |path, _| path.end_with?("redis.tf") }
            return [false, nil, nil] if redis_files.empty?

            hardcoded_version = nil
            var_name = nil

            redis_files.each_value do |content|
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

          def version_for_var(files_in_dir, var_name)
            production_tfvars_files = files_in_dir.select { |path, _| path.match?(%r{production\.tfvars(?:\.json)?$}i) }
            production_tfvars_files.each_value do |content|
              version_match = content.match(/#{Regexp.escape(var_name)}["\s:=]*"?([\d.]+)"?/)
              return version_match[1] if version_match
            end

            variable_files = files_in_dir.select { |path, _| path.end_with?("variables.tf") }
            variable_files.each_value do |content|
              default_match = content.match(/variable\s+"#{Regexp.escape(var_name)}"\s*\{[^}]*default\s*=\s*"?([\d.]+)"?/m)
              return default_match[1] if default_match
            end

            nil
          end

          def files_for(terraform_dir)
            @terraform_files.select do |path, _|
              path.start_with?("#{terraform_dir}/") && !path.include?("/vendor/")
            end
          end
        end
      end
    end
  end
end
