# frozen_string_literal: true

require 'api_versioner/unsupported_version'

module ApiVersioner
  class DefaultPolicy
    class VersionTooLow < UnsupportedVersion
      def initialize(msg)
        super(msg, reason: 'TOO_LOW')
      end
    end

    class VersionTooHigh < UnsupportedVersion
      def initialize(msg)
        super(msg, reason: 'TOO_HIGH')
      end
    end

    def call(current_version, requested_version)
      return on_version_unspecified unless requested_version

      on_lower(current_version, requested_version) if requested_version.major < current_version.major
      on_higher(current_version, requested_version) if requested_version > current_version

      true
    end

    private

    def on_version_unspecified
      # Ignore
    end

    def on_lower(current_version, requested_version)
      raise VersionTooLow,
        "Requested version (#{requested_version}) is significantly lower than current version (#{current_version})"
    end

    def on_higher(current_version, requested_version)
      raise VersionTooHigh,
        "Requested version (#{requested_version}) is higher than current version (#{current_version})"
    end
  end
end
