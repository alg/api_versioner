# frozen_string_literal: true

require 'versioner/version'

module Versioner
  autoload :Configuration, 'versioner/configuration'

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
require "versioner/railtie" if defined?(Rails::Railtie)
