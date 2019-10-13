require_relative 'request'

module ClientApi

  class Api < ClientApi::Request

    include ClientApi

    def initialize
      ((FileUtils.rm Dir.glob("./#{json_output['Dirname']}/*.json"); $roo = true)) if json_output && $roo == nil
    end

    def get(url, headers = nil)
      @output = get_request(url, :headers => headers)
      post_logger if $logger
    end

    def post(url, body, headers = nil)
      @output = post_request(url, :body => body, :headers => headers)
      post_logger if $logger
    end

    def delete(url, headers = nil)
      @output = delete_request(url, :headers => headers)
      post_logger if $logger
    end

    def put(url, body, headers = nil)
      @output = put_request(url, :body => body, :headers => headers)
      post_logger if $logger
    end

    def patch(url, body, headers = nil)
      @output = patch_request(url, :body => body, :headers => headers)
      post_logger if $logger
    end

    def status
      @output.code.to_i
    end

    def body
      unless @output.body == "" || @output.body.nil? || @output.body == "{}"
        unless json_output['Dirname'] == nil
          FileUtils.mkdir_p "#{json_output['Dirname']}"
          time_now = (Time.now.to_f).to_s.gsub('.','')
          File.open("./#{json_output['Dirname']}/#{json_output['Filename']+"_"+time_now}""#{time_now}"".json", "wb") {|file| file.puts JSON.pretty_generate(JSON.parse(@output.body))}
        end
        JSON.parse(@output.body)
      end
    end

    def message
      @output.message
    end

    def post_logger
      (@output.body == "" || @output.body.nil? || @output.body == "{}") ? res_body = 'empty response body' : res_body = body

      $logger.debug("Response code == #{@output.code.to_i}")
      $logger.debug("Response body == #{res_body}")
      $logger.debug("=====================================================================================")
    end

    alias :code :status
    alias :resp :body
  end

  def payload(path)
    JSON.parse(File.read(path))
  end

  alias :schema_from_json :payload

end