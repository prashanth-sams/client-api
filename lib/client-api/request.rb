require "net/http"
require 'openssl'

module ClientApi

  class Request

    include ClientApi

    def initialize(scenario)
      @scenario = scenario
      $logger.debug("Requested scenario == '#{@scenario.description}'") if $logger
    end

    def get_request(url, options = {})
      connect(url)
      pre_logger(:log_url => uri(url), :log_header => header(options), :log_method => 'GET') if $logger
      @http.get(uri(url).request_uri, initheader = header(options))
    end

    def post_request(url, options = {})
      body = options[:body] || {}
      connect(url)
      pre_logger(:log_url => uri(url), :log_header => header(options), :log_body => body, :log_method => 'POST') if $logger
      @http.post(uri(url).path, body.to_json, initheader = header(options))
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
      headers['Authorization'] = basic_encode(:username => basic_auth['Username'], :password => basic_auth['Password']) if authorization != "Basic Og=="
      headers.merge(mod_headers)
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