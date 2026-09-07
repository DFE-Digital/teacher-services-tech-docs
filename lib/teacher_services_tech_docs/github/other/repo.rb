module SchoolsDigitalTechDocs
  module GitHub
    class OtherRepo
      include MarkdownDocs
      include SchoolsDigitalTechDocs::GitHub::RepoProfiles

      attr_accessor :service_name

      def initialize(repo_name:, service_name:, language: "other", client: GitHub::Client.new)
        @repo_name = repo_name
        @service_name = service_name
        @language = language
        @client = client
      end

      def profile
        repo = @client.get_repo(@repo_name)

        BasicRepoProfile.new(service_name: @service_name, repo_name: @repo_name, repo:, language: @language)
      end
    end
  end
end
