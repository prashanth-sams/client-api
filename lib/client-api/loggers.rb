require 'logger'

module Loggers

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
end
