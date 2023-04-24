# frozen_string_literal: true

module ApiVersioner
  autoload :SemanticVersion, 'api_versioner/semantic_version'
  autoload :DefaultHandler, 'api_versioner/default_handler'
  autoload :DefaultPolicy, 'api_versioner/default_policy'

  # :reek:InstanceVariableAssumption
  # :reek:TooManyInstanceVariables
  class Configuration
    DEFAULT_SERVER_VERSION_HEADER = 'X-API-Server-Version'
    DEFAULT_CLIENT_VERSION_HEADER = 'X-API-Client-Version'

    attr_writer :version_policy, :unsupported_version_handler
    attr_reader :current_version, :server_version_header, :client_version_header

    def initialize
      @current_version = nil
      @server_version_header = DEFAULT_SERVER_VERSION_HEADER
      @client_version_header = DEFAULT_CLIENT_VERSION_HEADER
    end

    def version_policy
      @version_policy = DefaultPolicy.new unless instance_variable_defined?(:@version_policy)
      @version_policy
    end

    def unsupported_version_handler
      @unsupported_version_handler = DefaultHandler.new unless instance_variable_defined?(:@unsupported_version_handler)
      @unsupported_version_handler
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
