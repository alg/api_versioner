# frozen_string_literal: true

# :nocov:
module ApiVersioner
  autoload :ServerVersionMiddleware, 'api_versioner/server_version_middleware'
  autoload :ClientVersionMiddleware, 'api_versioner/client_version_middleware'

  class Railtie < Rails::Railtie
    initializer 'versioner.configure_rails_initialization' do |app|
      app.middleware.use ServerVersionMiddleware
      app.middleware.insert_after ServerVersionMiddleware, ClientVersionMiddleware
    end
  end
end
