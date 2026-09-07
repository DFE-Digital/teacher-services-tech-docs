require "json"

module SchoolsDigitalTechDocs
  module GitHub
    class RubyDependencies
      def initialize(service_name, lockfile:, tool_versions_file: nil, ruby_version_file: nil, node_version_file: nil, nvmrc_file: nil, yarnrc_file: nil, package_json_file: nil, yarn_lock_file: nil, production_environment_file: nil, dfe_analytics_initializer_file: nil)
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

      def node_version
        version = version_from_file(@node_version_file) ||
          version_from_file(@nvmrc_file) ||
          tool_version(%w[nodejs node]) ||
          parsed_package_json&.dig("volta", "node") ||
          parsed_package_json&.dig("engines", "node")

        version&.delete_prefix("v")
      end

      def yarn_version
        package_manager = parsed_package_json&.dig("packageManager")
        package_manager_match = package_manager&.match(/\Ayarn@(\S+)\z/)
        return package_manager_match[1] if package_manager_match

        tool_version_value = tool_version(["yarn"])
        return tool_version_value if tool_version_value.present?
        return "4.x (yarnrc.yml present)" if @yarnrc_file.present?
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
          production_environment_file: @production_environment_file
        )
      end

      def job_queues_detector
        @job_queues_detector ||= Ruby::Dependencies::JobQueues.new(
          service_name: @service_name,
          lockfile: @lockfile,
          package_json_file: @package_json_file,
          yarn_lock_file: @yarn_lock_file,
          production_environment_file: @production_environment_file
        )
      end

      def caching_detector
        @caching_detector ||= Ruby::Dependencies::Caching.new(
          service_name: @service_name,
          lockfile: @lockfile,
          package_json_file: @package_json_file,
          yarn_lock_file: @yarn_lock_file,
          production_environment_file: @production_environment_file
        )
      end

      def dfe_analytics_detector
        @dfe_analytics_detector ||= Ruby::Dependencies::DfeAnalytics.new(
          service_name: @service_name,
          lockfile: @lockfile,
          package_json_file: @package_json_file,
          yarn_lock_file: @yarn_lock_file,
          dfe_analytics_initializer_file: @dfe_analytics_initializer_file
        )
      end

      def parsed_lockfile
        if @lockfile
          @parsed_lockfile ||= Bundler::LockfileParser.new(@lockfile)
        end
      end

      def parsed_package_json
        return unless @package_json_file.present?

        @parsed_package_json ||= JSON.parse(@package_json_file)
      rescue JSON::ParserError => e
        raise "Invalid package.json in #{@service_name}: #{e.message}"
      end

      def version_from_file(file_contents)
        return unless file_contents.present?

        file_contents.split.last
      end

      def tool_version(tool_names)
        return unless @tool_versions_file.present?

        pattern = /\A(?:#{tool_names.join("|")})\s+\S+/
        matches = @tool_versions_file.split("\n").select { |line| line.match?(pattern) }
        return if matches.empty?

        raise "Tool versions file in #{@service_name} has multiple #{tool_names.join("/")} entries #{matches}" unless matches.length == 1

        matches.first.split.last
      end
    end
  end
end
