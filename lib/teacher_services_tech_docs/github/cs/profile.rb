module SchoolsDigitalTechDocs
  module GitHub
    module RepoProfiles
      class CsRepoProfile < Data.define(:service_name, :repo_name, :repo, :dependencies, :asdf)
        include BaseProfile
        extend Forwardable

        def_delegators :dependencies, :target_framework, :dfe_analytics_version

        def language
          "cs"
        end

        def asdf?
          asdf
        end

        def tech_stack
          {
            "framework" => target_framework,
            "dfe-analytics-net" => dfe_analytics_version,
          }
        end
      end
    end
  end
end
