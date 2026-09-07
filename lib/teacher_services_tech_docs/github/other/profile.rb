module SchoolsDigitalTechDocs
  module GitHub
    module RepoProfiles
      class BasicRepoProfile < Data.define(:service_name, :repo_name, :repo, :language)
        include BaseProfile

        def tech_stack
          {
            "language" => language,
          }
        end
      end
    end
  end
end
