# frozen_string_literal: true

require 'semantic'
require 'versioner/unsupported_version'

module Versioner
  class ClientVersionMiddleware
    def initialize(app, config = nil)
      @app = app
      @config = config || Versioner.config
    end

    def call(env)
      check_version(env)
      @app.(env)
    rescue Versioner::UnsupportedVersion => e
      @config.unsupported_version_handler.(e, @config)
    end

    def check_version(env)
      return unless checking_versions?

      @config.version_policy.(@config.current_version, client_version(env))
    end

    def checking_versions?
      @config.client_version_header &&
        @config.current_version &&
        @config.version_policy &&
        @config.unsupported_version_handler
    end

    def client_version(env)
      header_name = convert_to_rack_header(@config.client_version_header)
      ver = env[header_name]

      ver && Semantic::Version.new(ver)
    rescue ArgumentError
      nil
    end

    def convert_to_rack_header(header)
      "HTTP_#{header.strip.tr('-', '_').upcase}"
    end
  end
end
