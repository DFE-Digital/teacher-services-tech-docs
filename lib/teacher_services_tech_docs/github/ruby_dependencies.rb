module SchoolsDigitalTechDocs
  module GitHub
    class RubyDependencies
      def initialize(lockfile_contents)
        @parsed_lockfile = Bundler::LockfileParser.new(lockfile_contents)
      end

      def rails_version
        @parsed_lockfile.specs.find { |s| s.name == "rails" }.version.to_s
      end

      def dfe_analytics_version
        @parsed_lockfile.specs.find { |s| s.name == "dfe-analytics" }&.version&.to_s
      end

      def dfe_autocomplete_version
        @parsed_lockfile.specs.find { |s| s.name == "dfe-autocomplete" }&.version&.to_s
      end

      def dfe_reference_data_version
        @parsed_lockfile.specs.find { |s| s.name == "dfe-reference-data" }&.version&.to_s
      end

      def ruby_version
        if @parsed_lockfile.ruby_version
         return Gem::Version.new(@parsed_lockfile.ruby_version.gsub("ruby ", "")).release.to_s
        end

        ""
      end
    end
  end
end
