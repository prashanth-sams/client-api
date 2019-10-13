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

  def basic_auth
    ClientApi.configuration.basic_auth || ''
  end

  def json_output
    ClientApi.configuration.json_output || ''
  end

  def time_out
    ClientApi.configuration.time_out || ''
  end

end