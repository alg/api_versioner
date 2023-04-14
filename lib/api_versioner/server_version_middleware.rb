# frozen_string_literal: true

module ApiVersioner
  class ServerVersionMiddleware
    def initialize(app, config = nil)
      @app = app
      @config = config || ApiVersioner.config
    end

    def call(env)
      response = @app.(env) # status, headers, bodies
      add_version_header(response[1])
      response
    end

    private

    def add_version_header(headers)
      return unless adding_versions?

      headers[@config.server_version_header] = @config.current_version
    end

    def adding_versions?
      @config.current_version &&
        @config.server_version_header
    end
  end
end
