module TeacherServicesTechDocs
  module GitHub
    class Repo
      Profile = Struct.new(:name,
                           :rails,
                           :ruby,
                           :asdf,
                           :dfe_analytics,
                           :dfe_reference_data,
                           :dfe_autocomplete,
                           :default_branch,
                           keyword_init: true)

      def initialize(repo_name:, service_name:)
        @repo_name = repo_name
        @service_name = service_name
      end

      def profile
        lockfile = client.get_file(@repo_name, "Gemfile.lock")
        if lockfile.present?
          deps = GitHub::Dependencies.new(lockfile.contents)
        else
          return nil
        end

        has_tool_versions = client.get_file(@repo_name, ".tool-versions").present? ? true : false

        repo = client.get_repo(@repo_name)

        Profile.new(
          name: @repo_name,
          rails: deps.rails_version,
          dfe_analytics: deps.dfe_analytics_version,
          dfe_reference_data: deps.dfe_reference_data_version,
          dfe_autocomplete: deps.dfe_autocomplete_version,
          ruby: deps.ruby_version,
          asdf: has_tool_versions,
          default_branch: repo.default_branch,
        )
      end

      def load_docs(path_in_repo:, ignore_files: [])
        directory_contents = client.get_directory(@repo_name, path_in_repo)
        markdown_files = directory_contents.select { |doc| doc.name.end_with?(".md") && !doc.name.in?(ignore_files) }

        branch = client.get_repo(@repo_name).default_branch

        path_prefix = @repo_name.gsub("DFE-Digital", "services")

        pages = markdown_files.map do |file|
          markdown = GitHub::MarkdownFile.new(
            name: file.name,
            path: file.path,
            contents: client.get_file(@repo_name, file.path).contents,
          )

          {
            path: "#{path_prefix}/#{markdown.filename}.html",
            title: markdown.title,
            proxy_args: {
              locals: {
                service_name: @service_name,
                title: markdown.title,
                external_doc_contents: markdown.to_html(repo_name: @repo_name, branch:),
              },
              data: {
                # Title in search results
                category: @service_name,
                original_title: markdown.title,
                title: "#{@service_name} - #{markdown.title}",
                source_url: file.html_url,
              },
            },
          }
        end

        # Sort the pages by filename, ie the same way they're sorted in GitHub
        pages.sort_by do |page|
          page.fetch(:path)
        end
      end

    private

      def client
        GitHub::Client.new
      end
    end
  end
end
