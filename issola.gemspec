# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'issola/version'

Gem::Specification.new do |spec|
  spec.name          = 'issola'
  spec.version       = Issola::VERSION
  spec.authors       = ['Michael Senn']
  spec.email         = ['michael@morrolan.ch']

  spec.summary       = %q{Discord bot framework, built on top of `discordrb`}
  # spec.description   = %q{}
  spec.homepage      = 'https://github.com/Dragaera/issola'
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'discordrb', '~> 3.3.0'
  spec.add_runtime_dependency 'sequel'
  spec.add_runtime_dependency 'pg'
  spec.add_runtime_dependency 'sequel_pg'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'warning'
end

