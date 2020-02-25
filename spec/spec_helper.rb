require "bundler/setup"
require "client-api"
require "rspec"
require "rspec/expectations"
require "json"
require "dogapi"

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

  config.before(:all) do
    $api_key = ENV['API_KEY']
    $app_key = ENV['APP_KEY']

    dog = Dogapi::Client.new($api_key, $app_key)

    # dog.search_hosts()
    IO.write('/tmp/msg.txt', dog.search_hosts())

    # dog.service_check('app.is_ok', 'app1', 0, :message => 'Response: 200 OK', :tags => ['env:test'])
    # dog.emit_point('qa.baseline.website.desktop', 10, :host => dog.datadog_host, :device => "automation")
    # dog.emit_points('qa.baseline.website.desktop', [['passed', 5], ['failed', 2], ['pending', 0]])

    # dog = Dogapi::Client.new($api_key, $app_key)
    # dog.emit_points('qa.baseline.website.desktop', [['passed', 5], ['failed', 2], ['pending', 0]], :host => v, :device => "my_device")

    # p dog.datadog_host  # prints https://api.datadoghq.com

    # dog.add_tags("my_host", ["tagA", "tagB"])
    # dog.emit_event(Dogapi::Event.new('Testing done, FTW'), :host => "my_host")
    # dog.emit_point('some.metric.name', 50.0, :host => "my_host", :device => "my_device")
    # dog.emit_points('some.metric.name', [[t1, val1], [t2, val2], [t3, val3]], :host => "my_host", :device => "my_device")
  end
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