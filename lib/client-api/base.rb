module ClientApi

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
    if [200, 201, 204].include? status
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
    $logger.debug("Response headers == #{@output.headers}")
    $logger.debug("=====================================================================================")
  end

  def payload(path)
    JSON.parse(File.read(path))
  end

  def logger=(logs)
    output_logs_dir = logs['Dirname']
    output_logs_filename = logs['Filename']

    now = (Time.now.to_f * 1000).to_i
    $logger = Logger.new(STDOUT)
    $logger.datetime_format = '%Y-%m-%d %H:%M:%S'
    Dir.mkdir("./#{output_logs_dir}") unless File.exist?("./#{output_logs_dir}")

    if logs['StoreFilesCount'] && (logs['StoreFilesCount'] != nil || logs['StoreFilesCount'] != {} || logs['StoreFilesCount'] != empty)
      file_count = Dir["./#{output_logs_dir}/*.log"].length
      Dir["./#{output_logs_dir}/*.log"].sort_by {|f| File.ctime(f)}.reverse.last(file_count - "#{logs['StoreFilesCount']}".to_i).map {|junk_file| File.delete(junk_file)} if file_count > logs['StoreFilesCount']
    end

    $logger = Logger.new(File.new("#{output_logs_dir}/#{output_logs_filename}_#{now}.log", 'w'))
    $logger.level = Logger::DEBUG
  end

  alias :code :status
  alias :schema_from_json :payload
  alias :resp :body

end