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
        terraform_files = load_terraform_files

        lockfile = @client.get_file(@repo_name, "Gemfile.lock")&.contents
        tool_versions_file = @client.get_file(@repo_name, ".tool-versions")&.contents
        ruby_version_file = @client.get_file(@repo_name, ".ruby-version")&.contents
        node_version_file = @client.get_file(@repo_name, ".node-version")&.contents
        nvmrc_file = @client.get_file(@repo_name, ".nvmrc")&.contents
        yarnrc_file = @client.get_file(@repo_name, ".yarnrc.yml")&.contents
        package_json_file = @client.get_file(@repo_name, "package.json")&.contents
        yarn_lock_file = @client.get_file(@repo_name, "yarn.lock")&.contents
        production_environment_file = @client.get_file(@repo_name, "config/environments/production.rb")&.contents
        dfe_analytics_initializer_file = @client.get_file(@repo_name, "config/initializers/dfe_analytics.rb")&.contents

        deps = GitHub::RubyDependencies.new(
          @service_name,
          lockfile:,
          tool_versions_file:,
          ruby_version_file:,
          node_version_file:,
          nvmrc_file:,
          yarnrc_file:,
          package_json_file:,
          yarn_lock_file:,
          production_environment_file:,
          dfe_analytics_initializer_file:,
          terraform_files:
        )

        repo = @client.get_repo(@repo_name)

        Profile.new(
          service_name: @service_name,
          repo_name: @repo_name,
          repo: repo,
          dependencies: deps,
        )
      end

    private

      def load_terraform_files
        terraform_file_paths = @client.get_tree_paths(@repo_name).select do |path|
          path.start_with?("terraform/") &&
            !path.include?("/vendor/") &&
            path.match?(%r{(?:^|/)(?:production\.tfvars(?:\.json)?|.*\.tf)$})
        end

        terraform_file_paths.each_with_object({}) do |path, files|
          contents = @client.get_file(@repo_name, path)&.contents
          files[path] = contents if contents.present?
        end
      end
    end
  end
end
