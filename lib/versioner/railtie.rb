# frozen_string_literal: true

# :nocov:
require_relative './client_version_middleware'
require_relative './server_version_middleware'

module Versioner
  class Railtie < Rails::Railtie
    initializer 'versioner.configure_rails_initialization' do |app|
      app.middleware.use Versioner::ServerVersionMiddleware
      app.middleware.insert_after Versioner::ServerVersionMiddleware, Versioner::ClientVersionMiddleware
    end
  end
end
