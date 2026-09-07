module SchoolsDigitalTechDocs
  module GitHub
    module Ruby
      module Dependencies
        class DfeAnalytics < DependencyDetectorBase
          def value
            dfe_analytics_gem_version = get_dependency_version("dfe-analytics")
            has_dfe_analytics_gem = dfe_analytics_gem_version.present?
            has_airbyte = airbyte_enabled?

            return nil unless has_dfe_analytics_gem || has_airbyte

            labels = []
            labels << dfe_analytics_gem_version if has_dfe_analytics_gem
            labels << "Airbyte" if has_airbyte

            labels.join(" + ")
          end

        private
          def airbyte_enabled?
            return false unless dfe_analytics_initializer_file_content.present?

            dfe_analytics_initializer_file_content.split("\n").any? do |line|
              stripped_line = line.strip
              next false if stripped_line.start_with?("#")
              next false unless stripped_line.include?("airbyte_enabled")

              !stripped_line.match?(/airbyte_enabled\s*(?:=|:)\s*false\b/)
            end
          end
        end
      end
    end
  end
end
