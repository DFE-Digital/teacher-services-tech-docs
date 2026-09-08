module SchoolsDigitalTechDocs
  module GitHub
    module Ruby
      module Dependencies
        class JsCompilation < DependencyDetectorBase
          def value
            if webpack_detected?
              return format_js_compilation("Webpack", webpack_compiler_version)
            end

            if esbuild_detected_with_jsbundling?
              return format_js_compilation("esbuild", esbuild_version)
            end

            if webpack_script_detected_with_jsbundling?
              return format_js_compilation("Webpack", webpack_compiler_version)
            end

            if jsbundling_rails_version.present?
              return format_js_compilation("jsbundling-rails", jsbundling_rails_version)
            end

            "None detected"
          end

        private

          def format_js_compilation(compilation_tool_name, compilation_tool_version)
            return compilation_tool_name unless compilation_tool_version.present?

            "#{compilation_tool_name} #{compilation_tool_version}"
          end

          def jsbundling_rails_version
            get_dependency_version("jsbundling-rails")
          end

          def webpack_cli_version
            js_dependency_version("webpack-cli")
          end

          def esbuild_version
            js_dependency_version("esbuild")
          end

          def webpack_compiler_version
            shakapacker_version || webpack_version || webpack_cli_version
          end

          def webpack_detected?
            webpack_compiler_version.present? || get_dependency_version("shakapacker").present?
          end

          def esbuild_detected_with_jsbundling?
            esbuild_version.present? || build_script.include?("esbuild")
          end

          def webpack_script_detected_with_jsbundling?
            build_script.include?("webpack")
          end

          def build_script
            @build_script ||= [package_script("build"), package_script("build:js")].find(&:present?).to_s
          end

          def package_script(script_name)
            parsed_package_json&.dig("scripts", script_name)
          end
        end
      end
    end
  end
end
