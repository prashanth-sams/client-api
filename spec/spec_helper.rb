require "bundler/setup"
require "client-api"
require "rspec"
require "rspec/expectations"
require "json"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.filter_run_when_matching :focus
  config.expose_dsl_globally = true
end

ClientApi.configure do |config|
  config.base_url = 'https://staging.propertyfinder.ae/en/api'
  config.headers = {'Content-Type' => 'application/vnd.api+json', 'Accept' => 'application/vnd.api+json', 'X-Pf-JWT' => 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE1NzIzNTY1MDQsImV4cCI6MTU3NDk0ODUwNCwiaXNzIjoiYWUiLCJ1c2VySWQiOjMzODk2LCJ0eXBlIjoiTWFuYWdlckFwaSJ9.LWsfFdIMYenGcpePDoRFKMwCMDVGrHeRM1Ut8wTXfWU'}
  # config.basic_auth = {'Username' => 'ahamilton@apigee.com', 'Password' => 'myp@ssw0rd'}
  config.json_output = {'Dirname' => './output', 'Filename' => 'test'}
  config.time_out = 10  # in secs
  config.logger = {'Dirname' => './logs', 'Filename' => 'test', 'StoreFilesCount' => 2}

  config.before(:each) do |scenario|
    ClientApi::Request.new(scenario)
  end
end