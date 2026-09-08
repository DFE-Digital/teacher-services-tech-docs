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
        deps = GitHub::RubyDependencies.new(self)

        Profile.new(
          service_name: @service_name,
          repo_name: @repo_name,
          repo: @client.get_repo(@repo_name),
          dependencies: deps,
        )
      end

      def lockfile
        file("Gemfile.lock")
      end

      def tool_versions_file
        file(".tool-versions")
      end

      def ruby_version_file
        file(".ruby-version")
      end

      def node_version_file
        file(".node-version")
      end

      def nvmrc_file
        file(".nvmrc")
      end

      def yarnrc_file
        file(".yarnrc.yml")
      end

      def package_json_file
        file("package.json")
      end

      def yarn_lock_file
        file("yarn.lock")
      end

      def production_environment_file
        file("config/environments/production.rb")
      end

      def dfe_analytics_initializer_file
        file("config/initializers/dfe_analytics.rb")
      end

      def dockerfile
        file("Dockerfile")
      end

      def terraform_files
        @terraform_files ||= load_terraform_files
      end

    private

      def file(path)
        @files ||= {}
        return @files[path] if @files.key?(path)

        @files[path] = @client.get_file(@repo_name, path)&.contents
      end

      def load_terraform_files
        terraform_file_paths = @client.get_tree_paths(@repo_name).select do |path|
          next false unless path.start_with?("terraform/") && !path.include?("/vendor/")

          path.match?(%r{(?:^|/)(?:production\.tfvars(?:\.json)?|variables\.tf|database\.tf)$}) ||
            (path.end_with?(".tf") && path.match?(/redis/i))
        end

        terraform_file_paths.each_with_object({}) do |path, files|
          contents = @client.get_file(@repo_name, path)&.contents
          files[path] = contents if contents.present?
        end
      end
    end
  end
end
