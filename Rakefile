# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end


