# frozen_string_literal: true

module Versioner
  class Configuration
    DEFAULT_HEADER_NAME = 'X-API-SERVER-VERSION'

    attr_accessor :current_version, :header_name

    def initialize
      @current_version = nil
      @header_name = DEFAULT_HEADER_NAME
    end
  end
end
