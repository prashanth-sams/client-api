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
  config.base_url = 'https://reqres.in'
  config.headers = {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
  config.basic_auth = {'Username' => 'ahamilton@apigee.com', 'Password' => 'myp@ssw0rd'}
  config.json_output = {'Dirname' => './output', 'Filename' => 'test'}
  config.time_out = 10  # in secs
  config.logger = {'Dirname' => './logs', 'Filename' => 'test', 'StoreFilesCount' => 2}

  config.before(:each) do |scenario|
    ClientApi::Request.new(scenario)
  end
end