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
end