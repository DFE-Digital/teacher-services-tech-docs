module SchoolsDigitalTechDocs
  module GitHub
    class RubyDependencies
      def initialize(service_name, lockfile:, tool_versions_file: nil, ruby_version_file: nil)
        @service_name = service_name
        @lockfile = lockfile
        @tool_versions_file = tool_versions_file
        @ruby_version_file = ruby_version_file
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

      def parsed_lockfile
        if @lockfile
          @parsed_lockfile ||= Bundler::LockfileParser.new(@lockfile)
        end
      end
    end
  end
end
