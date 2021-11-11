# frozen_string_literal: true

module Versioner
  class UnsupportedVersion < StandardError
    attr_reader :reason

    def initialize(msg = nil, reason: nil)
      super(msg)

      @reason = reason
    end
  end
end
