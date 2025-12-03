module SchoolsDigitalTechDocs
  module GitHub
    class CsRepo
      include SchoolsDigitalTechDocs::GitHub::MarkdownDocs

      Profile = Struct.new(:name,
                           :target_framework,
                           :dfe_analytics_version,
                           :asdf,
                           :default_branch,
                           keyword_init: true)

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

        has_tool_versions = @client.get_file(@repo_name, ".tool-versions").present? ? true : false

        repo = @client.get_repo(@repo_name)

        Profile.new(
          name: @repo_name,
          target_framework: deps.target_framework,
          dfe_analytics_version: deps.dfe_analytics_version,
          asdf: has_tool_versions,
          default_branch: repo.default_branch,
        )
      end
    end
  end
end
