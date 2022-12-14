# frozen_string_literal: true

module ApiVersioner
  class ServerVersionMiddleware
    def initialize(app, config = nil)
      @app = app
      @config = config || ApiVersioner.config
    end

    def call(env)
      status, headers, response = @app.(env)

      add_version_header(headers)

      [status, headers, response]
    end

    private

    def add_version_header(headers)
      return unless adding_versions?

      headers[@config.server_version_header] = @config.current_version.to_s
    end

    def adding_versions?
      @config.current_version &&
        @config.server_version_header
    end
  end
end
