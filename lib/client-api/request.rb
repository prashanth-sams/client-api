require_relative '../client-api'

module ClientApi

  def get_request(url, options = {})
    http = Net::HTTP.new(uri(url).host, uri(url).port)
    http.use_ssl = true
    http.get(uri(url).request_uri, initheader = headers)
  end

  def post_request(url, options={})
    body = options[:body] || {}
    Net::HTTP.post_form(uri(url), body)
  end

  def delete_request(url, options={})
    http = Net::HTTP.new(uri(url).host, uri(url).port)
    http.use_ssl = true
    http.delete(uri(url).path)
  end

  def put_request(url, options={})
    body = options[:body] || {}
    http = Net::HTTP.new(uri(url).host, uri(url).port)
    http.use_ssl = true
    http.put(uri(url).path, body.to_json, initheader = headers)
  end

  def patch_request(url, options={})
    body = options[:body] || {}
    http = Net::HTTP.new(uri(url).host, uri(url).port)
    http.use_ssl = true
    http.patch(uri(url).path, body.to_json, initheader = headers)
  end

  def uri(args)
    URI.parse(base_url + args)
  end
end