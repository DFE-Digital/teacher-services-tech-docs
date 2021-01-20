CACHE = ActiveSupport::Cache::FileStore.new(".cache")

module HTTP
  def self.get_cached(url)
    CACHE.fetch(url, expires_in: 1.hour) do
      get(url)
    end
  end

  def self.get(url)
    uri = URI.parse(url)

    faraday = Faraday.new(url: uri) do |conn|
      conn.response :logger
      conn.use Faraday::HttpCache, serializer: Marshal, shared_cache: false
      conn.use Octokit::Response::RaiseError
      conn.response :json, content_type: /\bjson$/
      conn.adapter Faraday.default_adapter
    end

    response = faraday.get(uri.path)

    response.body
  end
end
