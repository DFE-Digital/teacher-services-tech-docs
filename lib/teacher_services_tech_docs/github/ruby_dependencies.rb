module TeacherServicesTechDocs
  module GitHub
    class RubyDependencies
      def initialize(lockfile_contents)
        @parsed_lockfile = Bundler::LockfileParser.new(lockfile_contents)
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

      def ruby_version
        Gem::Version.new(@parsed_lockfile.ruby_version.gsub("ruby ", "")).release.to_s
      end

    private

      def get_dependency_version(dep)
        @parsed_lockfile.specs.find { |s| s.name == dep }&.version&.to_s
      end
    end
  end
end
