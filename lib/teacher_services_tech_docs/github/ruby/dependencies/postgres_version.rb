module SchoolsDigitalTechDocs
  module GitHub
    module Ruby
      module Dependencies
        class PostgresVersion
          HARDCODED_SERVER_VERSION = /server_version\s*=\s*"?(\d+)"?/i
          POSTGRES_VERSION_IN_TFVARS = /postgres[_-](?:server[_-])?version["\s:=]*(\d+)/i
          POSTGRES_VERSION_VARIABLE_HEADER = /variable\s+"postgres(?:_server)?_version"\s*\{/i
          VARIABLE_DEFAULT_VALUE = /default\s*=\s*"?(\d+)"?/

          def initialize(terraform_files:)
            @files = TerraformFileSet.new(terraform_files)
          end

          def value
            postgres_version = hardcoded_database_version || production_tfvars_version || variables_default_version

            return "Unknown" unless postgres_version

            has_postgis? ? "#{postgres_version} + PostGIS" : postgres_version
          end

        private

          def has_postgis?
            database_files.any? { |_, content| content.include?("postgis") }
          end

          def hardcoded_database_version
            database_files.each_value do |content|
              next if content.include?("var.")

              version_match = content.match(HARDCODED_SERVER_VERSION)
              return version_match[1] if version_match
            end

            nil
          end

          def production_tfvars_version
            @files.production_tfvars_files.each_value do |content|
              version_match = content.match(POSTGRES_VERSION_IN_TFVARS)
              return version_match[1] if version_match
            end

            nil
          end

          def variables_default_version
            @files.variable_files.each_value do |content|
              TerraformBlockScanner.bodies(content, POSTGRES_VERSION_VARIABLE_HEADER).each do |variable_body|
                version_match = variable_body.match(VARIABLE_DEFAULT_VALUE)
                return version_match[1] if version_match
              end
            end

            nil
          end

          def database_files
            @files.files_ending_with("database.tf")
          end
        end
      end
    end
  end
end
