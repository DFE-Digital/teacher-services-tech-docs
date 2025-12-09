module SchoolsDigitalTechDocs
  module GitHub
    module RepoProfiles
      BasicRepoProfile = Struct.new(:service_name, :repo_name, :archived, :default_branch, keyword_init: true)
    end
  end
end
