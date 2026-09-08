module SchoolsDigitalTechDocs
  module GitHub
    module Ruby
      module Dependencies
        class LockfileLookup
          def initialize(lockfile)
            @lockfile = lockfile
          end

          def version_of(dep)
            parsed&.specs&.find { |s| s.name == dep }&.version&.to_s
          end

          def ruby_version_pin
            parsed&.ruby_version
          end

          def declared?(dep)
            parsed&.dependencies&.key?(dep)
          end

        private

          def parsed
            return unless @lockfile

            @parsed ||= Bundler::LockfileParser.new(@lockfile)
          end
        end
      end
    end
  end
end
