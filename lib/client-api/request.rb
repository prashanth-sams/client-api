require_relative '../client-api'

module ClientApi

  def get_request(url, options = {})
    connect(url)
    @http.get(uri(url).request_uri, initheader = header(options))
  end

  def post_request(url, options = {})
    body = options[:body] || {}
    connect(url)
    @http.post(uri(url).path, body.to_json, initheader = header(options))
  end

  def delete_request(url, options = {})
    connect(url)
    @http.delete(uri(url).path, initheader = header(options))
  end

  def put_request(url, options = {})
    body = options[:body] || {}
    connect(url)
    @http.put(uri(url).path, body.to_json, initheader = header(options))
  end

  def patch_request(url, options = {})
    body = options[:body] || {}
    connect(url)
    @http.patch(uri(url).path, body.to_json, initheader = header(options))
  end

  def uri(args)
    if %w[http://, https://].any? { |protocol| args.include? protocol }
      URI.parse(args)
    else
      URI.parse(base_url + args)
    end
  end

  def connect(args)
    http = Net::HTTP.new(uri(args).host, uri(args).port)

    if uri(args).scheme == "https"
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @http = http
    end
  end

  def basic_encode(options = {})
    'Basic ' + ["#{options[:username]}:#{options[:password]}"].pack('m0')
  end

  def header(options = {})
    mod_headers = options[:headers] || {}
    headers['Authorization'] = basic_encode(:username  => @@basic_auth_username, :password => @@basic_auth_password)
    headers.merge(mod_headers)
  end

end