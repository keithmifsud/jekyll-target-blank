# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name = 'jekyll-target-blank'
  spec.version = '0.1.0'
  spec.authors = ['Keith Mifsud']
  spec.email = ['mifsud.k@gmail.com']
  spec.summary = 'Target Blank automatically changes the external links to open in a new browser.'
  spec.description = 'Target Blank automatically changes the external links to open in a new browser.'
  spec.homepage = 'https://github.com/keithmifsud/jekyll-target-blank'
  spec.license = 'MIT'
  spec.files = `git ls-files -z`.split("\x0")
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'jekyll', '~> 3.0'
  spec.add_dependency 'rinku', '~> 1.7.0'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '0.55'
end
