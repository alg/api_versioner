# frozen_string_literal: true

module ApiVersioner
  autoload :UnsupportedVersion, 'api_versioner/unsupported_version'

  class ClientVersionMiddleware
    def initialize(app, config = nil)
      @app = app
      @config = config || ApiVersioner.config
    end

    def call(env)
      check_version(env)
      @app.(env)
    rescue ApiVersioner::UnsupportedVersion => e
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
      version_str = presence(env[header_name])
      return unless version_str

      SemanticVersion.new(version_str)
    rescue ArgumentError
      nil
    end

    def presence(str)
      return unless str

      str = str.strip
      str.empty? ? nil : str
    end

    def convert_to_rack_header(header)
      "HTTP_#{header.tr('-', '_').upcase}"
    end
  end
end
