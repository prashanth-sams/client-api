require_relative 'request'

module ClientApi

  class Api < ClientApi::Request

    include ClientApi

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
      if [200, 201, 202, 204].include? status
        unless json_output['Dirname'] == nil
          FileUtils.mkdir_p "#{json_output['Dirname']}"
          File.open("./output/#{json_output['Filename']}.json", "wb") {|file| file.puts JSON.pretty_generate(JSON.parse(@output.body))}
        end
        JSON.parse(@output.body)
      else
        JSON.parse(@output.message)
      end
    end

    def message
      @output.message
    end

    def post_logger
      (@output.body.nil? || @output.body == "{}") ? res_body = 'empty response body' : res_body = body

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