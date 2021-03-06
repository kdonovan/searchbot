# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'searchbot/version'

Gem::Specification.new do |spec|
  spec.name          = "searchbot"
  spec.version       = Searchbot::VERSION
  spec.authors       = ["Kali Donovan"]
  spec.email         = ["kali@deviantech.com"]

  spec.summary       = %q{Automate searching various business listing websites}
  spec.homepage      = "https://github.com/kdonovan/searchbot"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'nokogiri'
  spec.add_dependency 'hashie'
  spec.add_dependency 'httparty'
  spec.add_dependency 'dotenv'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'awesome_print'
end
