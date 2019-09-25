require_relative '../client-api'

module ClientApi

  def get_request(url, options = {})
    http = Net::HTTP.new(uri(url).host, uri(url).port)
    http.use_ssl = true
    http.get(uri(url).request_uri)
  end

  def post_request(url, options={})
    body = options[:body] || {}
    Net::HTTP.post_form(uri(url), body)
  end

  def uri(url)
    URI.parse(base_url + url)
  end
end