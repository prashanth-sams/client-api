require "client-api/version"
require "client-api/base"

# module Client
#   module Api
#     class Error < StandardError; end
#     # Your code goes here...
#   end
# end

RSpec.configure do |config|
  config.add_setting :base_url
  config.add_setting :headers

  config.include ClientAPI
end
