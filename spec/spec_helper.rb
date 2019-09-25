require "bundler/setup"
require "client-api"
require "rspec"
require "rspec/expectations"
require "net/http"
require "json"
require "byebug"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

ClientApi.configure do |config|
  config.base_url = 'https://reqres.in'
  config.headers = {'Content-Type' => 'application/json'}
end