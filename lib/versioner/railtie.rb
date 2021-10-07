# frozen_string_literal: true

# :nocov:
require_relative './middleware'

module Versioner
  class Railtie < Rails::Railtie
    initializer 'versioner.configure_rails_initialization' do |app|
      app.middleware.use Versioner::Middleware
    end
  end
end
