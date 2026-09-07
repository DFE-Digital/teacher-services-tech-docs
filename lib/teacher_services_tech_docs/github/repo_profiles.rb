module SchoolsDigitalTechDocs
  module GitHub
    module RepoProfiles
      module BaseProfile
        def repository_url
          "https://github.com/#{repo_name}"
        end

        def ruby?
          language == "ruby"
        end

        def cs?
          language == "cs"
        end

        def other?
          language == "other"
        end

        def default_branch
          repo.default_branch
        end

        def archived
          repo.archived
        end

        def tech_stack
          {}
        end
      end

      class BasicRepoProfile < Data.define(:service_name, :repo_name, :repo, :language)
        include BaseProfile

        def tech_stack
          {
            "language" => language,
          }
        end
      end

      class RubyRepoProfile < Data.define(:service_name, :repo_name, :repo, :dependencies)
        include BaseProfile
        extend Forwardable

        def_delegators :dependencies, :rails_version, :ruby_version, :dfe_analytics_version, :dfe_reference_data_version, :dfe_autocomplete_version
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
          }
        end
      end

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
