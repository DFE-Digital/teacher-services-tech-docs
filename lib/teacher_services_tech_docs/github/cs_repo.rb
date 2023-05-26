module TeacherServicesTechDocs
  module GitHub
    class CsRepo
      Profile = Struct.new(:name,
                           :target_framework,
                           :dfe_analytics_version,
                           :asdf,
                           :default_branch,
                           keyword_init: true)

      def initialize(repo_name:, service_name:, csproj_path:, client: GitHub::Client.new)
        @repo_name = repo_name
        @service_name = service_name
        @csproj_path = csproj_path
        @client = client
      end

      def profile
        csproj_file = @client.get_file(@repo_name, @csproj_path)

        if csproj_file.present?
          deps = GitHub::CsDependencies.new(csproj_file.contents)
        else
          return nil
        end

        has_tool_versions = @client.get_file(@repo_name, ".tool-versions").present? ? true : false

        repo = @client.get_repo(@repo_name)

        Profile.new(
          name: @repo_name,
          target_framework: deps.target_framework,
          dfe_analytics_version: deps.dfe_analytics_version,
          asdf: has_tool_versions,
          default_branch: repo.default_branch,
        )
      end

      def load_docs(path_in_repo:, ignore_files: [])
        directory_contents = @client.get_directory(@repo_name, path_in_repo)
        markdown_files = directory_contents.select { |doc| doc.name.end_with?(".md") && !doc.name.in?(ignore_files) }

        branch = @client.get_repo(@repo_name).default_branch

        path_prefix = @repo_name.gsub("DFE-Digital", "services")

        pages = markdown_files.map do |file|
          markdown = GitHub::MarkdownFile.new(
            name: file.name,
            path: file.path,
            contents: @client.get_file(@repo_name, file.path).contents,
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
    end
  end
end
