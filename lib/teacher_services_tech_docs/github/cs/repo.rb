module SchoolsDigitalTechDocs
  module GitHub
    class CsRepo
      include SchoolsDigitalTechDocs::GitHub::MarkdownDocs

      attr_reader :service_name

      Profile = RepoProfiles::CsRepoProfile

      def initialize(repo_name:, service_name:, csproj_path:, client: GitHub::Client.new)
        @repo_name = repo_name
        @service_name = service_name
        @csproj_path = csproj_path
        @client = client
      end

      def profile
        csproj_file = @client.get_file(@repo_name, @csproj_path)

        if csproj_file.present?
          deps = GitHub::CsDependencies.new(csproj_file.contents)
        else
          return nil
        end

        has_tool_versions = @client.get_file(@repo_name, ".tool-versions").present? || false

        repo = @client.get_repo(@repo_name)

        Profile.new(
          service_name: @service_name,
          repo_name: @repo_name,
          repo: repo,
          dependencies: deps,
          asdf: has_tool_versions,
        )
      end
    end
  end
end
