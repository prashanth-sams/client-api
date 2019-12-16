require "net/http"
require 'openssl'

module ClientApi

  class Request
    attr_accessor :base_url, :basic_auth, :json_output, :time_out, :headers

    def initialize(configure = ClientApi.configuration)
      @base_url = configure.base_url
      @headers = configure.headers
      @basic_auth = configure.basic_auth
      @json_output = configure.json_output
      @time_out = configure.time_out
    end

    def get_request(url, options = {})
      connect(url)
      pre_logger(:log_url => uri(url), :log_header => header(options), :log_method => 'GET') if $logger
      @http.get(uri(url).request_uri, initheader = header(options))
    end

    def get_with_body_request(url, options = {})
      body = options[:body] || {}
      connect(url)
      pre_logger(:log_url => uri(url), :log_header => header(options), :log_body => body, :log_method => 'GET') if $logger

      request = Net::HTTP::Get.new(uri(url))
      request.body = body.to_json
      header(options).each { |key,value| request.add_field(key,value)}
      @http.request(request)
    end

    def post_request(url, options = {})
      body = options[:body] || {}
      connect(url)
      pre_logger(:log_url => uri(url), :log_header => header(options), :log_body => body, :log_method => 'POST') if $logger
      @http.post(uri(url).path, body.to_json, initheader = header(options))
    end

    def post_request_x(url, options = {})
      body = options[:body]
      connect(url)

      request = Net::HTTP::Post.new(uri(url))
      body['data'].each { |key,value| request.set_form([[key.to_s,File.open(value)]], body['type'])}
      final_header =  header(options).delete_if{ |k,| ['Content-Type', 'content-type', 'Content-type', 'content-Type'].include? k }
      final_header.each { |key,value| request.add_field(key,value)}

      pre_logger(:log_url => uri(url), :log_header => header(options), :log_body => body, :log_method => 'POST') if $logger
      @http.request(request)
    end

    def delete_request(url, options = {})
      connect(url)
      pre_logger(:log_url => uri(url), :log_header => header(options), :log_method => 'DELETE') if $logger
      @http.delete(uri(url).path, initheader = header(options))
    end

    def put_request(url, options = {})
      body = options[:body] || {}
      connect(url)
      pre_logger(:log_url => uri(url), :log_header => header(options), :log_body => body, :log_method => 'PUT') if $logger
      @http.put(uri(url).path, body.to_json, initheader = header(options))
    end

    def patch_request(url, options = {})
      body = options[:body] || {}
      connect(url)
      pre_logger(:log_url => uri(url), :log_header => header(options), :log_body => body, :log_method => 'PATCH') if $logger
      @http.patch(uri(url).path, body.to_json, initheader = header(options))
    end

    def uri(args)
      if (args.include? "http://") || (args.include? "https://")
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
        http.read_timeout = time_out.to_i
        @http = http
      elsif uri(args).scheme == "http"
        http.use_ssl = false
        http.read_timeout = time_out.to_i
        @http = http
      end
    end

    def basic_encode(options = {})
      'Basic ' + ["#{options[:username]}:#{options[:password]}"].pack('m0')
    end

    def header(options = {})
      mod_headers = options[:headers] || {}
      authorization = basic_encode(:username => basic_auth['Username'], :password => basic_auth['Password'])
      if headers == nil || headers == ""
        @headers = {}
      else
        @headers = headers
      end
      @headers['Authorization'] = authorization if authorization != "Basic Og=="
      @headers.merge(mod_headers)
    end

    def pre_logger(options = {})
      options[:log_body] = 'not available' if options[:log_body].nil?
      $logger.debug("Requested method == #{options[:log_method]}")
      $logger.debug("Requested url == #{options[:log_url]}")
      $logger.debug("Requested headers == #{options[:log_header]}")
      $logger.debug("Requested body == #{options[:log_body]}")
    end
  end

end