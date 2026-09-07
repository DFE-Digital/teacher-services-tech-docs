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

    end
  end
end
