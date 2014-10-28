# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scriptster/version'

Gem::Specification.new do |spec|
  spec.name          = "scriptster"
  spec.version       = Scriptster::VERSION
  spec.authors       = ["Radek Pazdera"]
  spec.email         = ["radek@pazdera.co.uk"]
  spec.summary       = %q{Making your Ruby scipts hip.}
  spec.description   = %q{A simple library for making your scipts a bit nicer.}
  spec.homepage      = "https://github.com/pazdera/scriptster"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "tco", "~> 0.1"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.1"
  spec.add_development_dependency "rspec", "~> 3.1"
end
