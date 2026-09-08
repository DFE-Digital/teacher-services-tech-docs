module SchoolsDigitalTechDocs
  module GitHub
    module Ruby
      module Dependencies
        class PostgresVersion
          TERRAFORM_DIRS = [
            "terraform/aks",
            "terraform/application",
            "terraform",
          ].freeze

          def initialize(terraform_files:)
            @terraform_files = terraform_files
          end

          def value
            postgres_version = nil
            has_postgis = false

            TERRAFORM_DIRS.each do |terraform_dir|
              files_in_dir = files_for(terraform_dir)

              production_tfvars_files = files_in_dir.select { |path, _| path.match?(%r{production\.tfvars(?:\.json)?$}i) }
              production_tfvars_files.each_value do |content|
                version_match = content.match(/postgres[_-](?:server[_-])?version["\s:=]*(\d+)/i)
                postgres_version = version_match[1] if version_match
              end

              unless postgres_version
                variable_files = files_in_dir.select { |path, _| path.end_with?("variables.tf") }
                variable_files.each_value do |content|
                  version_match = content.match(/variable\s+"postgres(?:_server)?_version"\s*\{[^}]*default\s*=\s*"?(\d+)"?/mi)
                  postgres_version = version_match[1] if version_match
                end
              end

              database_files = files_in_dir.select { |path, _| path.end_with?("database.tf") }
              database_files.each_value do |content|
                has_postgis = true if content.include?("postgis")
                hardcoded_version = content.match(/server_version\s*=\s*"?(\d+)"?/i)
                if hardcoded_version && !content.include?("var.")
                  postgres_version = hardcoded_version[1]
                end
              end
            end

            return "Unknown" unless postgres_version

            if has_postgis
              "#{postgres_version} + PostGIS"
            else
              postgres_version
            end
          end

        private

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
