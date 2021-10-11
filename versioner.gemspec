# frozen_string_literal: true

require_relative 'lib/versioner/version'

Gem::Specification.new do |spec|
  spec.name          = 'versioner'
  spec.version       = Versioner::VERSION
  spec.authors       = ['Aleksey Gureiev']
  spec.email         = %w[agureiev@shakuro.com]

  spec.summary       = 'A simple gem to add semantic versioning support to API applications.'
  spec.homepage      = 'https://github.com/alg/versioner'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/alg/versioner'
  spec.metadata['changelog_uri'] = 'https://github.com/alg/versioner/CHANGELOG'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_dependency 'semantic', '~> 1.6.1'

  spec.add_development_dependency 'reek', '~> 6.0'
  spec.add_development_dependency 'rspec', '~> 3.10.0'
  spec.add_development_dependency 'rubocop', '~> 1.4'
  spec.add_development_dependency 'rubocop-performance', '~> 1.5', '>= 1.5.2'
  spec.add_development_dependency 'rubocop-rails', '~> 2.2'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.0'
  spec.add_development_dependency 'simplecov', '~> 0.21.2'
end
