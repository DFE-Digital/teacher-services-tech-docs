module SchoolsDigitalTechDocs
  module GitHub
    class Client
      def get_file(repo, path)
        file_resource = client.contents(repo, path:)
        GitHub::File.new(file_resource)
      rescue Octokit::NotFound
        nil
      end

      def get_directory(repo, path)
        client.contents(repo, path:)
      rescue Octokit::NotFound
        []
      end

      def get_repo(repo)
        client.repo(repo)
      end

      def get_tree_paths(repo)
        default_branch = get_repo(repo).default_branch
        tree = client.tree(repo, default_branch, recursive: true)
        tree.tree.select { |entry| entry.type == "blob" }.map(&:path)
      rescue Octokit::NotFound
        []
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

          github_client = Octokit::Client.new(access_token: SchoolsDigitalTechDocs::GITHUB_TOKEN)
          github_client.auto_paginate = true
          github_client
        end
      end
    end
  end
end
