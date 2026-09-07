module SchoolsDigitalTechDocs
  module GitHub
    module RepoProfiles
      class RubyRepoProfile < Data.define(:service_name, :repo_name, :repo, :dependencies)
        include BaseProfile
        extend Forwardable

        def_delegators :dependencies,
          :rails_version,
          :ruby_version,
          :dfe_analytics_version,
          :dfe_reference_data_version,
          :dfe_autocomplete_version,
          :css_compilation,
          :js_compilation,
          :asset_management,
          :job_queues,
          :caching
        def_delegator :dependencies, :has_tool_versions?, :asdf?

        def language
          "ruby"
        end

        def tech_stack
          {
            "rails" => rails_version,
            "ruby" => ruby_version,
            "dfe-analytics" => dfe_analytics_version,
            "dfe-reference-data" => dfe_reference_data_version,
            "dfe-autocomplete" => dfe_autocomplete_version,
            "job-queues" => job_queues,
            "caching" => caching,
            "asset-management" => asset_management,
            "css-compilation" => css_compilation,
            "js-compilation" => js_compilation,
          }
        end
      end
    end
  end
end
