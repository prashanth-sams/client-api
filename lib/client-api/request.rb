require_relative '../client-api'

module ClientApi

  def get_request(url, options = {})
    connect(url)
    @http.get(uri(url).request_uri, initheader = headers)
  end

  def post_request(url, options = {})
    body = options[:body] || {}
    Net::HTTP.post_form(uri(url), body)
  end

  def delete_request(url, options = {})
    connect(url)
    @http.delete(uri(url).path)
  end

  def put_request(url, options = {})
    body = options[:body] || {}

    connect(url)
    @http.put(uri(url).path, body.to_json, initheader = headers)
  end

  def patch_request(url, options = {})
    body = options[:body] || {}

    connect(url)
    @http.patch(uri(url).path, body.to_json, initheader = headers)
  end

  def uri(args)
    URI.parse(base_url + args)
  end

  def connect(args)
    http = Net::HTTP.new(uri(args).host, uri(args).port)

    if uri(args).scheme == "https"
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @http = http
    end
  end

end