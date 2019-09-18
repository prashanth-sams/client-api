require_relative '../client-api'

module ClientAPI

  def client_request(method, url, options={})
    headers = options[:headers] || {}

    uri = URI.parse(base_url+url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.get(uri.request_uri)
  end

  def base_url
    ClientAPI.configuration.base_url || ''
  end

end