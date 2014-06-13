# -*- encoding: utf-8 -*-
require File.expand_path('../lib/clamd/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'clamd'
  gem.version       = Clamd::VERSION
  gem.authors       = ['Soundarapandian Rathinasamy']
  gem.email         = ['soundar.rathinasamy@gmail.com']
  gem.description   = %q{Ruby gem to interact with ClamAV daemon(Clamd)}
  gem.summary       = %q{Clamd gem enables you to feed the simple VERSION command to
                         complex INSTREAM command to ClamAV antivirus daemon(Clamd)}
  gem.homepage      = 'https://github.com/soundarapandian/clamd'
  gem.license       = 'MIT'
  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
