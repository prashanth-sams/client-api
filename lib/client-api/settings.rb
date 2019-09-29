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
    @@basic_auth_username =  args['Username']
    @@basic_auth_password =  args['Password']
  end

  def json_output=(args)
    @@output_json_dir = args['Dirname']
    @@output_json_filename = args['Filename']
  end

end