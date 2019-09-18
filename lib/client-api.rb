require "client-api/version"
require "client-api/base"
require "client-api/client_request"

RSpec.configure do |config|
  config.add_setting :base_url
  config.add_setting :headers

  config.include ClientAPI
end