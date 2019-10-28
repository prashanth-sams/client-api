lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "client-api/version"

Gem::Specification.new do |spec|
  spec.name          = "client-api"
  spec.version       = ClientApi::VERSION
  spec.authors       = ["Prashanth Sams"]
  spec.email         = ["sams.prashanth@gmail.com"]

  spec.summary       = "HTTP Rest Api client for RSpec test automation framework that binds within itself"
  spec.homepage      = "https://github.com/prashanth-sams/client-api"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/prashanth-sams/client-api"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/github/prashanth-sams/client-api/master"
  spec.metadata["bug_tracker_uri"] = "https://github.com/prashanth-sams/client-api/issues"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = ["lib/client-api.rb", "lib/client-api/base.rb", "lib/client-api/loggers.rb", "lib/client-api/request.rb", "lib/client-api/settings.rb", "lib/client-api/validator.rb", "lib/client-api/version.rb"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug", "~> 11.0"

  spec.add_runtime_dependency "json-schema", '~> 2.8'
  spec.add_runtime_dependency "logger", "~> 1.0"
end
