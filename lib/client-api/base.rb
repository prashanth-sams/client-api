
module ClientAPI

  def self.configure
    RSpec.configure do |config|
      yield config
    end
  end

  def self.configuration
    RSpec.configuration
  end

  def get(url, headers = nil)
    response = client_request(:get, url, headers: headers)
    @status = response.code.to_i
    @body = response.body
  end

end