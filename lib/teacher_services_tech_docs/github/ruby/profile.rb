module SchoolsDigitalTechDocs
  module GitHub
    module RepoProfiles
      class RubyRepoProfile < Data.define(:service_name, :repo_name, :repo, :dependencies)
        include BaseProfile
        extend Forwardable

        PRIMARY_TECH_STACK_KEYS = %w[ruby rails postgres alpine node yarn redis].freeze

        def_delegators :dependencies,
                       :rails_version,
                       :ruby_version,
                       :node_version,
                       :yarn_version,
                       :dfe_analytics_version,
                       :dfe_reference_data_version,
                       :dfe_autocomplete_version,
                       :css_compilation,
                       :js_compilation,
                       :asset_management,
                       :job_queues,
                       :caching,
                       :postgres_version,
                       :redis_version,
                       :alpine_version
        def_delegator :dependencies, :has_tool_versions?, :asdf?

        def language
          "ruby"
        end

        def tech_stack
          {
            "ruby" => ruby_version,
            "rails" => rails_version,
            "postgres" => postgres_version,
            "alpine" => alpine_version,
            "node" => node_version,
            "yarn" => yarn_version,
            "redis" => redis_version,
            "asset-management" => asset_management,
            "caching" => caching,
            "css-compilation" => css_compilation,
            "dfe-analytics" => dfe_analytics_version,
            "dfe-autocomplete" => dfe_autocomplete_version,
            "dfe-reference-data" => dfe_reference_data_version,
            "job-queues" => job_queues,
            "js-compilation" => js_compilation,
          }
        end

        def primary_tech_stack
          split_tech_stack.first
        end

      private

        def split_tech_stack
          [tech_stack.slice(*PRIMARY_TECH_STACK_KEYS), tech_stack.except(*PRIMARY_TECH_STACK_KEYS)]
        end
      end
    end
  end
end
