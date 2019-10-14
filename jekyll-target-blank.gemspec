# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-target-blank/version'

Gem::Specification.new do |spec|
  spec.name = 'jekyll-target-blank'
  spec.version = JekyllTargetBlank::VERSION
  spec.authors = ['Keith Mifsud']
  spec.email = ['mifsud.k@gmail.com']
  spec.summary = 'Target Blank automatically changes the external links to open in a new browser.'
  spec.description = 'Target Blank automatically changes the external links to open in a new browser for Jekyll sites.'
  spec.homepage = 'https://github.com/keithmifsud/jekyll-target-blank'
  spec.license = 'MIT'
  spec.files = `git ls-files -z`.split("\x0")
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.3.0'
  spec.add_dependency 'jekyll', '>= 3.0', '<5.0'
  spec.add_dependency 'nokogiri', '~> 1.10'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '>= 0.68.0', '<= 0.72.0'
  spec.add_development_dependency "rubocop-jekyll", "~> 0.10.0"

end
