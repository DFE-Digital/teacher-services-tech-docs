module SchoolsDigitalTechDocs
  module GitHub
    class OtherRepo
      include SchoolsDigitalTechDocs::GitHub::RepoProfiles

      attr_accessor :service_name

      def initialize(repo_name:, service_name:, client: GitHub::Client.new)
        @repo_name = repo_name
        @service_name = service_name
        @client = client
      end

      def profile
        repo = @client.get_repo(@repo_name)

        BasicRepoProfile.new(service_name: @service_name, repo_name: @repo_name, archived: repo.archived, default_branch: repo.default_branch)
      end
    end
  end
end
