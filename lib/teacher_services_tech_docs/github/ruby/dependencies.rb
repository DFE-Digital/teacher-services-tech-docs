module SchoolsDigitalTechDocs
  module GitHub
    class RubyDependencies
      def initialize(service_name, lockfile:, tool_versions_file: nil, ruby_version_file: nil, node_version_file: nil, nvmrc_file: nil, yarnrc_file: nil, package_json_file: nil, yarn_lock_file: nil, production_environment_file: nil, dfe_analytics_initializer_file: nil, terraform_files: {}, dockerfile: nil)
        @service_name = service_name
        @lockfile = lockfile
        @tool_versions_file = tool_versions_file
        @ruby_version_file = ruby_version_file
        @node_version_file = node_version_file
        @nvmrc_file = nvmrc_file
        @yarnrc_file = yarnrc_file
        @package_json_file = package_json_file
        @yarn_lock_file = yarn_lock_file
        @production_environment_file = production_environment_file
        @dfe_analytics_initializer_file = dfe_analytics_initializer_file
        @terraform_files = terraform_files
        @dockerfile = dockerfile
      end

      def rails_version
        get_dependency_version("rails")
      end

      def dfe_analytics_version
        dfe_analytics_detector.value
      end

      def dfe_autocomplete_version
        get_dependency_version("dfe-autocomplete")
      end

      def dfe_reference_data_version
        get_dependency_version("dfe-reference-data")
      end

      def has_tool_versions?
        @tool_versions_file.present?
      end

      def css_compilation
        css_compilation_detector.value
      end

      def js_compilation
        js_compilation_detector.value
      end

      def asset_management
        asset_management_detector.value
      end

      def job_queues
        job_queues_detector.value
      end

      def caching
        caching_detector.value
      end

      def ruby_version
        ruby_version_detector.value
      end

      def node_version
        node_version_detector.value
      end

      def yarn_version
        yarn_version_detector.value
      end

      def postgres_version
        postgres_version_detector.value
      end

      def redis_version
        redis_version_detector.value
      end

      def alpine_version
        alpine_version_detector.value
      end

    private

      def get_dependency_version(dep)
        parsed_lockfile && parsed_lockfile.specs.find { |s| s.name == dep }&.version&.to_s
      end

      def css_compilation_detector
        @css_compilation_detector ||= Ruby::Dependencies::CssCompilation.new(
          service_name: @service_name,
          lockfile: @lockfile,
          package_json_file: @package_json_file,
          yarn_lock_file: @yarn_lock_file
        )
      end

      def js_compilation_detector
        @js_compilation_detector ||= Ruby::Dependencies::JsCompilation.new(
          service_name: @service_name,
          lockfile: @lockfile,
          package_json_file: @package_json_file,
          yarn_lock_file: @yarn_lock_file
        )
      end

      def asset_management_detector
        @asset_management_detector ||= Ruby::Dependencies::AssetManagement.new(
          service_name: @service_name,
          lockfile: @lockfile
        )
      end

      def job_queues_detector
        @job_queues_detector ||= Ruby::Dependencies::JobQueues.new(
          service_name: @service_name,
          lockfile: @lockfile
        )
      end

      def caching_detector
        @caching_detector ||= Ruby::Dependencies::Caching.new(
          service_name: @service_name,
          lockfile: @lockfile,
          production_environment_file: @production_environment_file
        )
      end

      def dfe_analytics_detector
        @dfe_analytics_detector ||= Ruby::Dependencies::DfeAnalytics.new(
          service_name: @service_name,
          lockfile: @lockfile,
          dfe_analytics_initializer_file: @dfe_analytics_initializer_file
        )
      end

      def ruby_version_detector
        @ruby_version_detector ||= Ruby::Dependencies::RubyVersion.new(
          service_name: @service_name,
          lockfile: @lockfile,
          tool_versions_file: @tool_versions_file,
          ruby_version_file: @ruby_version_file,
        )
      end

      def node_version_detector
        @node_version_detector ||= Ruby::Dependencies::NodeVersion.new(
          service_name: @service_name,
          node_version_file: @node_version_file,
          nvmrc_file: @nvmrc_file,
          tool_versions_file: @tool_versions_file,
          package_json_file: @package_json_file
        )
      end

      def yarn_version_detector
        @yarn_version_detector ||= Ruby::Dependencies::YarnVersion.new(
          service_name: @service_name,
          tool_versions_file: @tool_versions_file,
          yarnrc_file: @yarnrc_file,
          package_json_file: @package_json_file
        )
      end

      def postgres_version_detector
        @postgres_version_detector ||= Ruby::Dependencies::PostgresVersion.new(terraform_files: @terraform_files)
      end

      def redis_version_detector
        @redis_version_detector ||= Ruby::Dependencies::RedisVersion.new(terraform_files: @terraform_files)
      end

      def alpine_version_detector
        @alpine_version_detector ||= Ruby::Dependencies::AlpineVersion.new(dockerfile: @dockerfile)
      end

      def parsed_lockfile
        if @lockfile
          @parsed_lockfile ||= Bundler::LockfileParser.new(@lockfile)
        end
      end
    end
  end
end
