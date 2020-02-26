require "bundler/setup"
require "client-api"
require "rspec"
require "rspec/expectations"
require "json"
require "dogapi"
require "byebug"

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

  $data ||= []
  $passed = $failed = $pending = 0
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

  config.after(:each) do |scenario|
    if (scenario.exception) && (!scenario.exception.message.include? 'pending')
      status_id = 0
    elsif scenario.skipped?
      status_id = 2
    elsif scenario.pending?
      status_id = 2
    else
      status_id = 1
    end

    $data << {'status_id' => status_id, 'scenario' => scenario.description}
  end

  config.after(:all) do
    $data.map do |value|
      $failed += 1 if value['status_id'] == 0
      $passed += 1 if value['status_id'] == 1
      $pending += 1 if value['status_id'] == 2
    end

    dog = Dogapi::Client.new(ENV['API_KEY'], ENV['APP_KEY'])
    dog.batch_metrics do
      dog.emit_point('qa.baseline.website.passed',$passed)
      dog.emit_point('qa.baseline.website.failed', $failed)
      dog.emit_point('qa.baseline.website.pending', $pending)
    end
  end

end