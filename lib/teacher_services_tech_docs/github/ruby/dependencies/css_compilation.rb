module SchoolsDigitalTechDocs
  module GitHub
    module Ruby
      module Dependencies
        class CssCompilation < CompilationBase
          def value
            if cssbundling_rails_version.present?
              return format_css_compilation("cssbundling-rails", cssbundling_rails_version)
            end

            if shakapacker_version.present?
              return format_css_compilation("Shakapacker", shakapacker_version)
            end

            if webpack_version.present?
              return format_css_compilation("Webpack", webpack_version)
            end

            "Unknown"
          end

        private

          def format_css_compilation(compilation_tool_name, compilation_tool_version)
            compilation = "#{compilation_tool_name} #{compilation_tool_version}"
            sass = sass_version_label
            return compilation unless sass.present?

            "#{compilation} + #{sass}"
          end

          def cssbundling_rails_version
            get_dependency_version("cssbundling-rails")
          end

          def shakapacker_version
            js_dependency_version("shakapacker") || get_dependency_version("shakapacker")
          end

          def webpack_version
            js_dependency_version("webpack") || get_dependency_version("webpacker")
          end

          def sass_version_label
            if js_dependency_version("sass").present?
              return "Sass #{js_dependency_version("sass")}"
            end

            gem_sass_version = sass_gem_version
            return "Sass #{gem_sass_version}" if gem_sass_version.present?

            if js_dependency_version("sass-loader").present?
              return "Sass (sass-loader #{js_dependency_version("sass-loader")})"
            end
          end

          def sass_gem_version
            get_dependency_version("sassc-rails") ||
              get_dependency_version("sass-rails") ||
              get_dependency_version("sassc") ||
              get_dependency_version("sass")
          end
        end
      end
    end
  end
end
