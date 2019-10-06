lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "client-api/version"

Gem::Specification.new do |spec|
  spec.name          = "client-api"
  spec.version       = ClientApi::VERSION
  spec.authors       = ["prashanth-sams"]
  spec.email         = ["sams.prashanth@gmail.com"]

  spec.summary       = %q{HTTP Rest API client for RSpec Api Test framework}
  spec.description   = %q{client-api helps you write api tests quickly using rspec with different levels of validations}
  spec.homepage      = "https://github.com/prashanth-sams/client-api"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/prashanth-sams/client-api"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/github/prashanth-sams/client-api/master"
  spec.metadata["bug_tracker_uri"] = "https://github.com/prashanth-sams/client-api/issues"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "json-schema", "~> 2.0"
  spec.add_development_dependency "logger", "~> 1.0"
end
