# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name                  = 'rb-net_http-client'
  spec.version               = NetHTTP::VERSION
  spec.authors               = ['Ryan Bostian']
  spec.email                 = ['rab0309@gmail.com']
  spec.summary               = 'A Simple Ruby HTTP Client'
  spec.description           = 'A Simple Ruby HTTP Client built on top of the Ruby Net HTTP standard library.'
  spec.homepage              = 'https://github.com/rabos5/rb-net_http-client'
  spec.license               = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org/'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files = []
  spec.files += Dir.glob('lib/**/*.rb')
  spec.files += Dir.glob('lib/**/*.erb')
  spec.files += Dir.glob('*/**/*spec.rb')
  spec.require_paths = ['lib']

  # spec.files += Dir.glob('lib/config/**/*.yml')
  # spec.files += Dir.glob('scripts/**/*')

  # Runtime dependencies.
  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'dry-validation'
  spec.add_runtime_dependency 'nokogiri'
  spec.add_runtime_dependency 'rexml'

  # Development dependencies.
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'cucumber'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-checkstyle_formatter'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-cobertura'
  spec.add_development_dependency 'simplecov-json'
  spec.add_development_dependency 'simplecov-rcov'
  spec.add_development_dependency 'webmock'
end
