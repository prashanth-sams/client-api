module ClientApi

  def self.configure
    RSpec.configure do |config|
      yield config
    end
  end

  def self.configuration
    RSpec.configuration
  end

  def self.base_url
    ClientApi.configuration.base_url || ''
  end

  def self.headers
    ClientApi.configuration.headers || ''
  end

  def output=(args)
    $output_json_dir = args['dirname']
    $output_json_filename = args['filename']
  end

end