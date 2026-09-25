module SchoolsDigitalTechDocs
  module GitHub
    module Ruby
      module Dependencies
        class TerraformFileSet
          def initialize(terraform_files)
            @terraform_files = terraform_files
          end

          def production_tfvars_files
            non_vendor.select { |path, _| path.match?(%r{production\.tfvars(?:\.json)?$}i) }
          end

          def variable_files
            non_vendor.select { |path, _| path.end_with?("variables.tf") }
          end

          def files_ending_with(suffix)
            non_vendor.select { |path, _| path.end_with?(suffix) }
          end

          def each_content(&block)
            non_vendor.each_value(&block)
          end

        private

          def non_vendor
            @terraform_files.reject { |path, _| path.include?("/vendor/") }
          end
        end
      end
    end
  end
end
