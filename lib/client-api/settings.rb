require 'logger'

module ClientApi

  def self.configure
    RSpec.configure do |config|
      yield config
    end
  end

  def self.configuration
    RSpec.configuration
  end

  def base_url
    ClientApi.configuration.base_url || ''
  end

  def headers
    ClientApi.configuration.headers || ''
  end

  def basic_auth=(args)
    @@basic_auth_username = args['Username']
    @@basic_auth_password = args['Password']
  end

  def json_output=(args)
    @@output_json_dir = args['Dirname']
    @@output_json_filename = args['Filename']
  end

  def logger=(args)
    output_logs_dir = args['Dirname']
    output_logs_filename = args['Filename']

    now = (Time.now.to_f * 1000).to_i
    $logger = Logger.new(STDOUT)
    $logger.datetime_format = '%Y-%m-%d %H:%M:%S'
    Dir.mkdir("./#{output_logs_dir}") unless File.exist?("./#{output_logs_dir}")

    if args['StoreFilesCount'] && (args['StoreFilesCount'] != nil || args['StoreFilesCount'] != {} || args['StoreFilesCount'] != empty)
      file_count = Dir["./#{output_logs_dir}/*.log"].length
      Dir["./#{output_logs_dir}/*.log"].sort_by {|f| File.ctime(f)}.reverse.last(file_count - "#{args['StoreFilesCount']}".to_i).map {|junk_file| File.delete(junk_file)} if file_count > args['StoreFilesCount']
    end

    $logger = Logger.new(File.new("#{output_logs_dir}/#{output_logs_filename}_#{now}.log", 'w'))
    $logger.level = Logger::DEBUG
  end

end