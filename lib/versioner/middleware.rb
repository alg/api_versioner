# frozen_string_literal: true

module Versioner
  class Middleware
    def initialize(app, config = nil)
      @app = app

      config ||= Versioner.config
      @current_version = config.current_version&.strip
      @header_name = config.header_name&.strip

      @enabled =
        !@current_version.to_s.empty? &&
        !@header_name.to_s.empty?
    end

    def call(env)
      status, headers, response = @app.(env)

      add_version_header(headers)

      [status, headers, response]
    end

    private

    def add_version_header(headers)
      return headers unless @enabled

      headers[@header_name] = @current_version
    end
  end
end
