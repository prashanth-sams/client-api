
module ClientAPI

  def self.configure
    RSpec.configure do |config|
      yield config
    end
  end

end