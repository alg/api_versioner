# frozen_string_literal: true

require_relative 'lib/api_versioner/version'

Gem::Specification.new do |spec|
  spec.name          = 'api_versioner'
  spec.version       = ApiVersioner::VERSION
  spec.authors       = ['Aleksey Gureiev']
  spec.email         = %w[agureiev@shakuro.com]

  spec.summary       = 'A simple gem to add semantic versioning support to API applications.'
  spec.homepage      = 'https://github.com/alg/api_versioner'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/alg/api_versioner'
  spec.metadata['changelog_uri'] = 'https://github.com/alg/api_versioner/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]
end
