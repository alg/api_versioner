# frozen_string_literal: true

require_relative 'default_policy'
require_relative 'default_handler'

module ApiVersioner
  # :reek:TooManyInstanceVariables
  class Configuration
    DEFAULT_SERVER_VERSION_HEADER = 'X-API-Server-Version'
    DEFAULT_CLIENT_VERSION_HEADER = 'X-API-Client-Version'
    DEFAULT_VERSION_POLICY = DefaultPolicy.new
    DEFAULT_UNSUPPORTED_VERSION_HANDLER = DefaultHandler.new

    attr_accessor :version_policy, :unsupported_version_handler
    attr_reader :current_version, :server_version_header, :client_version_header

    def initialize
      @current_version = nil
      @server_version_header = DEFAULT_SERVER_VERSION_HEADER
      @client_version_header = DEFAULT_CLIENT_VERSION_HEADER
      @version_policy = DEFAULT_VERSION_POLICY
      @unsupported_version_handler = DEFAULT_UNSUPPORTED_VERSION_HANDLER
    end

    def current_version=(version)
      ver = version.to_s.strip
      @current_version = ver.empty? ? nil : SemanticVersion.new(ver)
    end

    def server_version_header=(name)
      val = name.to_s.strip
      @server_version_header = val.empty? ? nil : val
    end

    def client_version_header=(name)
      val = name.to_s.strip
      @client_version_header = val.empty? ? nil : val
    end
  end
end
