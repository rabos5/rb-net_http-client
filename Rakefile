# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

# $ rake rubocop
desc 'Executes rubocop syntax check'
task :rubocop do |_task|
  sh 'bundle exec rubocop \
      --require rubocop/formatter/checkstyle_formatter \
      --format RuboCop::Formatter::CheckstyleFormatter -o reports/xml/checkstyle-result.xml \
      --format html -o reports/html/index.html || true'
end

# $ rake unit_tests
# $ SIMPLECOV='true' rake unit_tests
desc 'Executes unit tests'
task :unit_tests do |_task, args|
  rm_rf 'reports/spec_results'
  ENV['SIMPLECOV_SPEC_SUITE'] = 'unit'
  sh "rspec spec/unit --format RspecJunitFormatter --out reports/spec_results/#{ENV['SIMPLECOV_SPEC_SUITE']}_spec_results.xml"
end
