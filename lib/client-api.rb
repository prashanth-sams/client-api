require "client-api/version"
require "client-api/settings"
require "client-api/base"
require "client-api/request"
require "client-api/validator"
require "client-api/loggers"

RSpec.configure do |config|
  config.add_setting :base_url
  config.add_setting :headers
  config.add_setting :basic_auth
  config.add_setting :json_output
  config.add_setting :time_out
  config.include ClientApi
end

include Loggers