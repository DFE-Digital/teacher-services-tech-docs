module TeacherServicesTechDocs
  module GitHub
    class Repo
      def initialize(repo_name:, service_name:)
        @repo_name = repo_name
        @service_name = service_name
      end

      def load_docs(path_in_repo:, ignore_files: [])
        directory_contents = client.contents(@repo_name, path: path_in_repo)
        branch = client.repo(@repo_name).default_branch
        markdown_files = directory_contents.select { |doc| doc.name.end_with?(".md") && !doc.name.in?(ignore_files) }
        path_prefix = @repo_name.gsub("DFE-Digital", "services")

        pages = markdown_files.map do |file|
          markdown = GitHub::MarkdownFile.new(name: file.name, path: file.path, contents: Base64.decode64(client.contents(@repo_name, path: file.path).content))

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
        @client ||= begin
          cache = ActiveSupport::Cache::FileStore.new(".cache", expires_in: 12.hours)

          stack = Faraday::RackBuilder.new do |builder|
            builder.response :logger, nil, { headers: false, bodies: false }
            builder.use FaradayMiddleware::Caching, cache
            builder.use Octokit::Response::RaiseError
            builder.use Faraday::Request::Retry, exceptions: Faraday::Request::Retry::DEFAULT_EXCEPTIONS + [Octokit::ServerError]
            builder.adapter Faraday.default_adapter
          end

          Octokit.middleware = stack

          github_client = Octokit::Client.new(access_token: TeacherServicesTechDocs::GITHUB_TOKEN)
          github_client.auto_paginate = true
          github_client
        end
      end
    end
  end
end
