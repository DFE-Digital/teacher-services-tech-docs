module SchoolsDigitalTechDocs
  module GitHub
    class RubyDependencies
      def initialize(lockfile:, tool_versions_file: nil, ruby_version_file: nil)
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

      def has_tool_versions
        @tool_versions_file.present?
      end

      def ruby_version
        version = if parsed_lockfile && parsed_lockfile.ruby_version.present?
                    parsed_lockfile.ruby_version.gsub("ruby ", "")
                  elsif @ruby_version_file.present?
                    @ruby_version_file
                    # TODO: support reading ruby version from tool-versions if not in Gemfile
                    # (no repos do this rn)
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
