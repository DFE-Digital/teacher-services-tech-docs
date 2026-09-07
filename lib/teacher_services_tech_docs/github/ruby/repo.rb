module SchoolsDigitalTechDocs
  module GitHub
    class RubyRepo
      include MarkdownDocs

      attr_reader :service_name

      Profile = RepoProfiles::RubyRepoProfile

      def initialize(repo_name:, service_name:, client: GitHub::Client.new)
        @repo_name = repo_name
        @service_name = service_name
        @client = client
      end

      def profile
        lockfile = @client.get_file(@repo_name, "Gemfile.lock")&.contents
        tool_versions_file = @client.get_file(@repo_name, ".tool-versions")&.contents
        ruby_version_file = @client.get_file(@repo_name, ".ruby-version")&.contents
        package_json_file = @client.get_file(@repo_name, "package.json")&.contents
        yarn_lock_file = @client.get_file(@repo_name, "yarn.lock")&.contents

        deps = GitHub::RubyDependencies.new(
          @service_name, lockfile:, tool_versions_file:, ruby_version_file:, package_json_file:, yarn_lock_file:
        )

        repo = @client.get_repo(@repo_name)

        Profile.new(
          service_name: @service_name,
          repo_name: @repo_name,
          repo: repo,
          dependencies: deps,
        )
      end
    end
  end
end
