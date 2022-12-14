# frozen_string_literal: true

require 'json'

module ApiVersioner
  class DefaultHandler
    BLANK_RE = /\A[[:space:]]*\z/.freeze

    def call(error, _config)
      [400, {}, [JSON.generate(errors: [formatted_error(error)])]]
    end

    private

    def formatted_error(error)
      {
        title: error.message,
        status: 400,
        code: 'UNSUPPORTED_VERSION'
      }.tap do |json|
        reason = error.reason
        next if !reason || BLANK_RE.match?(reason)

        json[:meta] = { reason: reason }
      end
    end
  end
end
