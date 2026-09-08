module SchoolsDigitalTechDocs
  module GitHub
    module Ruby
      module Dependencies
        class AlpineVersion
          def initialize(dockerfile:)
            @dockerfile = dockerfile
          end

          def value
            return "Unknown" unless @dockerfile.present?

            arg_values = parse_arg_defaults

            @dockerfile.each_line do |line|
              from_match = line.chomp.match(/\AFROM\s+(.+?)(?:\s+AS\s+.+)?\z/i)
              next unless from_match

              resolved_image = resolve_image(from_match[1].strip, arg_values)

              version_match = resolved_image.match(/alpine(\d+\.\d+)/)
              return version_match[1] if version_match

              return "unspecified" if resolved_image.match?(/-alpine\s*\z/)
            end

            "Unknown"
          end

        private

          def parse_arg_defaults
            @dockerfile.scan(/^\s*ARG\s+(\w+)=(.+)/).each_with_object({}) do |(name, value), args|
              args[name] = value.strip.delete_prefix('"').delete_suffix('"').delete_prefix("'").delete_suffix("'")
            end
          end

          def resolve_image(image, arg_values)
            var_ref = image.match(/\$\{(\w+)\}/)
            return arg_values[var_ref[1]] if var_ref && arg_values[var_ref[1]]

            image
          end
        end
      end
    end
  end
end
