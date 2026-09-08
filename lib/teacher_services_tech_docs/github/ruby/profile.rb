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
          primary = full_tech_stack.slice(*PRIMARY_TECH_STACK_KEYS)
          rest = full_tech_stack.except(*PRIMARY_TECH_STACK_KEYS).sort.to_h

          primary.merge(rest)
        end

        def primary_tech_stack
          full_tech_stack.slice(*PRIMARY_TECH_STACK_KEYS)
        end

      private

        def full_tech_stack
          {
            "rails" => rails_version,
            "ruby" => ruby_version,
            "node" => node_version,
            "yarn" => yarn_version,
            "dfe-analytics" => dfe_analytics_version,
            "dfe-reference-data" => dfe_reference_data_version,
            "dfe-autocomplete" => dfe_autocomplete_version,
            "job-queues" => job_queues,
            "caching" => caching,
            "postgres" => postgres_version,
            "redis" => redis_version,
            "alpine" => alpine_version,
            "asset-management" => asset_management,
            "css-compilation" => css_compilation,
            "js-compilation" => js_compilation,
          }
        end
      end
    end
  end
end
