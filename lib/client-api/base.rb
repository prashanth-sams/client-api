require_relative 'request'

module ClientApi

  class Api < ClientApi::Request

    include ClientApi

    def initialize
      ((FileUtils.rm Dir.glob("./#{json_output['Dirname']}/*.json"); $roo = true)) if json_output && $roo == nil
    end

    def get(url, headers = nil)
      @output = get_request(url, :headers => headers)
      self.post_logger if $logger
      self.output_json_body if json_output
    end

    def get_with_body(url, body = nil, headers = nil)
      @output = get_with_body_request(url, :body => body, :headers => headers)
      self.post_logger if $logger
      self.output_json_body if json_output
    end

    def post(url, body, headers = nil)
      if body.is_a? Hash
        if body['type'] && body['data']
          @output = post_request_x(url, :body => body, :headers => headers)
        else
          @output = post_request(url, :body => body, :headers => headers)
        end
      else
        raise 'invalid body'
      end

      self.post_logger if $logger
      self.output_json_body if json_output
    end

    def delete(url, headers = nil)
      @output = delete_request(url, :headers => headers)
      self.post_logger if $logger
      self.output_json_body if json_output
    end

    def put(url, body, headers = nil)
      @output = put_request(url, :body => body, :headers => headers)
      self.post_logger if $logger
      self.output_json_body if json_output
    end

    def patch(url, body, headers = nil)
      @output = patch_request(url, :body => body, :headers => headers)
      self.post_logger if $logger
      self.output_json_body if json_output
    end

    def status
      @output.code.to_i
    end

    def body
      unless ['', nil, '{}'].any? { |e| e == @output.body } || pdf_response_header
        JSON.parse(%{#{@output.body}})
      end
    end

    def output_json_body
      unless ['', nil, '{}'].any? { |e| e == @output.body } || pdf_response_header
        unless json_output['Dirname'] == nil
          FileUtils.mkdir_p "#{json_output['Dirname']}"
          time_now = (Time.now.to_f).to_s.gsub('.','')
          begin
            File.open("./#{json_output['Dirname']}/#{json_output['Filename']+"_"+time_now}""#{time_now}"".json", "wb") {|file| file.puts JSON.pretty_generate(JSON.parse(@output.body))}
          rescue StandardError => e
            raise("\n"+" Not a compatible (or) Invalid JSON response  => [kindly check the uri & request details]".brown + " \n\n #{e.message}")
          end
        end
      end
    end

    def response_headers
      resp_headers = {}
      @output.response.each { |key, value|  resp_headers.merge!(key.to_s => value.to_s) }
    end

    def pdf_response_header
      response_headers.map do |data|
        if data[0].downcase == 'Content-Type'.downcase && (data[1][0].include? 'application/pdf')
          return true
        end
      end
      false
    end

    def message
      @output.message
    end

    def post_logger
      ((['', nil, '{}'].any? { |e| e == @output.body }) || pdf_response_header) ? res_body = 'empty response body' : res_body = body

      $logger.debug("Response code == #{@output.code.to_i}")
      $logger.debug("Response body == #{res_body}")

      log_headers = {}
      @output.response.each { |key, value|  log_headers.merge!(key.to_s => value.to_s) }
      $logger.debug("Response headers == #{log_headers}")
      $logger.debug("=====================================================================================")
    end

    alias :code :status
    alias :resp :body
  end

  def payload(args)
    if args['type'].nil?
      JSON.parse(File.read(args))
    else
      case args['type'].downcase
      when 'multipart/form-data', 'application/x-www-form-urlencoded'
        args
      else
        raise "invalid body type | try: payload('./data/request/file.png', 'multipart/form-data')"
      end
    end
  end

  alias :schema_from_json :payload

end