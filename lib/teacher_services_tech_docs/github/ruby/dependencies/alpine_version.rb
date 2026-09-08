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

            final_stage_image = from_images.last
            return "Unknown" unless final_stage_image

            resolved_image = resolve_image(final_stage_image, parse_arg_defaults)

            version_match = resolved_image.match(/alpine(\d+\.\d+)/)
            return version_match[1] if version_match

            return "unspecified" if resolved_image.match?(/-alpine\s*\z/)

            "Unknown"
          end

        private

          def from_images
            @dockerfile.each_line.filter_map do |line|
              from_match = line.chomp.match(/\AFROM\s+(.+?)(?:\s+AS\s+.+)?\z/i)
              from_match && from_match[1].strip
            end
          end

          def parse_arg_defaults
            @dockerfile.scan(/^\s*ARG\s+(\w+)=(.+)/).each_with_object({}) do |(name, value), args|
              args[name] = value.strip.delete_prefix('"').delete_suffix('"').delete_prefix("'").delete_suffix("'")
            end
          end

          def resolve_image(image, arg_values, seen = [])
            var_ref = image.match(/\$\{(\w+)\}/)
            return image unless var_ref

            var_name = var_ref[1]
            return image if seen.include?(var_name) || !arg_values[var_name]

            resolve_image(arg_values[var_name], arg_values, seen + [var_name])
          end
        end
      end
    end
  end
end
