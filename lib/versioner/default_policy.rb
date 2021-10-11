# frozen_string_literal: true

module Versioner
  class DefaultPolicy
    def call(server_version, client_version)
      return on_version_unspecified unless client_version

      on_major_diff(server_version, client_version) if server_version.major != client_version.major
      on_greater(server_version, client_version) if client_version > server_version

      true
    end

    private

    def on_version_unspecified
      # Ignore
    end

    def on_major_diff(server_version, client_version)
      raise IncompatibleVersion, "The major version number differs between #{server_version} and #{client_version}"
    end

    def on_greater(server_version, client_version)
      raise IncompatibleVersion,
        "The client version (#{client_version}) is greater than server version (#{server_version})"
    end
  end
end
