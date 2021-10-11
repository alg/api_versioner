# frozen_string_literal: true

require 'semantic'
require_relative 'default_policy'
require_relative 'default_handler'

module Versioner
  # :reek:TooManyInstanceVariables
  class Configuration
    DEFAULT_SERVER_VERSION_HEADER = 'X-API-Server-Version'
    DEFAULT_CLIENT_VERSION_HEADER = 'X-API-Client-Version'
    DEFAULT_VERSION_POLICY = Versioner::DefaultPolicy.new
    DEFAULT_INCOMPATIBLE_VERSION_HANDLER = Versioner::DefaultHandler.new

    attr_accessor :version_policy, :incompatible_version_handler
    attr_reader :current_version, :server_version_header, :client_version_header

    def initialize
      @current_version = nil
      @server_version_header = DEFAULT_SERVER_VERSION_HEADER
      @client_version_header = DEFAULT_CLIENT_VERSION_HEADER
      @version_policy = DEFAULT_VERSION_POLICY
      @incompatible_version_handler = DEFAULT_INCOMPATIBLE_VERSION_HANDLER
    end

    def current_version=(version)
      ver = version.to_s.strip
      @current_version = ver.empty? ? nil : Semantic::Version.new(ver)
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
