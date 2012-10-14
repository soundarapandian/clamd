# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clamd/version'

Gem::Specification.new do |gem|
  gem.name          = "clamd"
  gem.version       = Clamd::VERSION
  gem.authors       = ["soundarapandian rathinasamy"]
  gem.email         = ["soundar.rathinasamy@gmail.com"]
  gem.description   = %q{Ruby gem to interact with Clamd daemon}
  gem.summary       = %q{Ruby gem to interact with Clamd daemon}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
