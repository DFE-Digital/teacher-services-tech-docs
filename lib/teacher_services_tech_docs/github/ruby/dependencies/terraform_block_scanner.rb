module SchoolsDigitalTechDocs
  module GitHub
    module Ruby
      module Dependencies
        module TerraformBlockScanner
          def self.bodies(content, header_pattern)
            lines = content.lines
            bodies = []
            index = 0

            while index < lines.length
              line = lines[index]

              unless line.match?(header_pattern)
                index += 1
                next
              end

              depth = line.count("{") - line.count("}")
              body_lines = []
              index += 1

              while index < lines.length && depth.positive?
                line = lines[index]
                depth += line.count("{") - line.count("}")
                body_lines << line if depth.positive?
                index += 1
              end

              bodies << body_lines.join
            end

            bodies
          end
        end
      end
    end
  end
end
