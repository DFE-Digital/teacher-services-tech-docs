module TeacherServicesTechDocs
  module GitHub
    class RubyRepo
      include MarkdownDocs

      attr_reader :service_name

      Profile = Struct.new(:name,
                           :rails,
                           :ruby,
                           :asdf,
                           :dfe_analytics,
                           :dfe_reference_data,
                           :dfe_autocomplete,
                           :default_branch,
                           keyword_init: true)

      def initialize(repo_name:, service_name:, client: GitHub::Client.new)
        @repo_name = repo_name
        @service_name = service_name
        @client = client
      end

      def profile
        lockfile = @client.get_file(@repo_name, "Gemfile.lock")
        if lockfile.present?
          deps = GitHub::RubyDependencies.new(lockfile.contents)
        else
          return nil
        end

        has_tool_versions = @client.get_file(@repo_name, ".tool-versions").present? ? true : false

        repo = @client.get_repo(@repo_name)

        Profile.new(
          name: @repo_name,
          rails: deps.rails_version,
          dfe_analytics: deps.dfe_analytics_version,
          dfe_reference_data: deps.dfe_reference_data_version,
          dfe_autocomplete: deps.dfe_autocomplete_version,
          ruby: deps.ruby_version,
          asdf: has_tool_versions,
          default_branch: repo.default_branch,
        )
      end
    end
  end
end
