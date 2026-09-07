module SchoolsDigitalTechDocs
  module GitHub
    class RubyDependencies
      def initialize(service_name, lockfile:, tool_versions_file: nil, ruby_version_file: nil, package_json_file: nil, yarn_lock_file: nil, gemfile_file: nil, production_environment_file: nil)
        @service_name = service_name
        @lockfile = lockfile
        @tool_versions_file = tool_versions_file
        @ruby_version_file = ruby_version_file
        @package_json_file = package_json_file
        @yarn_lock_file = yarn_lock_file
        @gemfile_file = gemfile_file
        @production_environment_file = production_environment_file
      end

      def rails_version
        get_dependency_version("rails")
      end

      def dfe_analytics_version
        get_dependency_version("dfe-analytics")
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
        version = if parsed_lockfile && parsed_lockfile.ruby_version.present?
                    parsed_lockfile.ruby_version.gsub("ruby ", "")
                  elsif @ruby_version_file.present?
                    @ruby_version_file.split.last
                  elsif @tool_versions_file.present?
                    ruby_versions = @tool_versions_file.split("\n").select { |s| s[/ruby/] }

                    raise "Tool versions file in #{@service_name} has no Ruby entry #{@tool_versions_file}" if ruby_versions.empty?

                    raise "Tool versions file in #{@service_name} has multiple Ruby entries #{ruby_versions}" unless ruby_versions.length == 1

                    ruby_versions.first.split.last
                  end

        Gem::Version.new(version).release.to_s if version
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
          lockfile: @lockfile,
          package_json_file: @package_json_file,
          yarn_lock_file: @yarn_lock_file,
          gemfile_file: @gemfile_file,
          production_environment_file: @production_environment_file
        )
      end

      def job_queues_detector
        @job_queues_detector ||= Ruby::Dependencies::JobQueues.new(
          service_name: @service_name,
          lockfile: @lockfile,
          package_json_file: @package_json_file,
          yarn_lock_file: @yarn_lock_file,
          gemfile_file: @gemfile_file,
          production_environment_file: @production_environment_file
        )
      end

      def caching_detector
        @caching_detector ||= Ruby::Dependencies::Caching.new(
          service_name: @service_name,
          lockfile: @lockfile,
          package_json_file: @package_json_file,
          yarn_lock_file: @yarn_lock_file,
          gemfile_file: @gemfile_file,
          production_environment_file: @production_environment_file
        )
      end

      def parsed_lockfile
        if @lockfile
          @parsed_lockfile ||= Bundler::LockfileParser.new(@lockfile)
        end
      end
    end
  end
end
