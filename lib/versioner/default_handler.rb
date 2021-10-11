# frozen_string_literal: true

require 'json'

module Versioner
  class DefaultHandler
    def call(error, _config)
      response = {
        errors: [
          {
            title: error.message,
            status: 400,
            code: 'UNSUPPORTED_VERSION'
          }
        ]
      }

      [400, {}, [JSON.generate(response)]]
    end
  end
end
