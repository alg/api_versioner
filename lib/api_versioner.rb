# frozen_string_literal: true

require 'api_versioner/version'

module ApiVersioner
  autoload :Configuration, 'api_versioner/configuration'
  autoload :SemanticVersion, 'api_versioner/semantic_version'

  class << self
    def configure
      yield(config)
    end

    def config
      @config ||= Configuration.new
    end
  end
end

# :nocov:
require 'api_versioner/railtie' if defined?(Rails::Railtie)
