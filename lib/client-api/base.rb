module ClientApi

  def get(url, headers = nil)
    @output = get_request(url, :headers => headers)
  end

  def post(url, body, headers = nil)
    @output = post_request(url, :body => body, :headers => headers)
  end

  def delete(url, headers = nil)
    @output = delete_request(url, :headers => headers)
  end

  def put(url, body, headers = nil)
    @output = put_request(url, :body => body, :headers => headers)
  end

  def patch(url, body, headers = nil)
    @output = patch_request(url, :body => body, :headers => headers)
  end

  def status
    @output.code.to_i
  end

  def body
    if [200, 201, 204].include? status
      unless @@output_json_dir == nil
        FileUtils.mkdir_p "#{@@output_json_dir}"
        File.open("./output/#{@@output_json_filename}.json", "wb") {|file| file.puts JSON.pretty_generate(JSON.parse(@output.body))}
      end
      JSON.parse(@output.body)
    else
      JSON.parse(@output.message)
    end
  end

  def message
    @output.message
  end

  def payload(path)
    JSON.parse(File.read(path))
  end

  alias :code :status
  alias :schema_from_json :payload

end