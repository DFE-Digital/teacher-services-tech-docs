module SchoolsDigitalTechDocs
  module GitHub
    module Ruby
      module Dependencies
        class AssetManagement < CompilationBase
          def value
            assets = []

            assets << format_asset("Shakapacker", shakapacker_version) if shakapacker_version.present?
            assets << format_asset("Propshaft", propshaft_version) if propshaft_version.present?
            assets << format_asset("Sprockets", sprockets_version) if sprockets_version.present?

            return assets.join(", ") if assets.any?

            "Unknown"
          end

        private

          def format_asset(asset_name, asset_version)
            return asset_name unless asset_version.present?

            "#{asset_name} #{asset_version}"
          end

          def shakapacker_version
            get_dependency_version("shakapacker")
          end

          def propshaft_version
            get_dependency_version("propshaft")
          end

          def sprockets_version
            get_dependency_version("sprockets") || get_dependency_version("sprockets-rails")
          end
        end
      end
    end
  end
end
