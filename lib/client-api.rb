require "client-api/version"
require "client-api/settings"
require "client-api/base"
require "client-api/request"

RSpec.configure do |config|
  config.add_setting :base_url
  config.add_setting :headers
  config.include ClientApi
end

include ClientApi