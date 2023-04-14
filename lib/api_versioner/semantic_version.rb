# frozen_string_literal: true

require 'forwardable'

module ApiVersioner
  class SemanticVersion
    extend Forwardable
    include Comparable

    # https://semver.org
    REGEXP = /\A(?<major>0|[1-9]\d*)\.(?<minor>0|[1-9]\d*)\.(?<patch>0|[1-9]\d*)(?:-(?<prerelease>(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+(?<buildmetadata>[0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?\z/.freeze # rubocop:disable Layout/LineLength

    def initialize(version)
      match = REGEXP.match(version)
      raise ArgumentError, "#{version.inspect} is not a valid SemVer Version (http://semver.org)" unless match

      @version = Version.new(match)
    end

    def_delegators :@version, :to_s, :major, :minor, :patch, :pre, :build, :prerelease_identifiers

    def <=>(other)
      other = SemanticVersion.new(other) if other.is_a?(String)
      Compare.new(self, other).()
    end
  end

  # :reek:TooManyInstanceVariables
  class Version
    NUMERIC = /\A0|[1-9]\d*\z/.freeze

    attr_reader :version, :major, :minor, :patch, :pre, :build, :prerelease_identifiers

    def initialize(regexp_match)
      @version = regexp_match.string
      @major = regexp_match[:major].to_i
      @minor = regexp_match[:minor].to_i
      @patch = regexp_match[:patch].to_i
      @pre = regexp_match[:prerelease]
      @build = regexp_match[:buildmetadata]
      @prerelease_identifiers = parse_prerelease_identifiers(@pre)
    end

    def to_s
      version
    end

    private

    def parse_prerelease_identifiers(pre)
      return nil unless pre

      pre.split('.').map! { |id| NUMERIC.match?(id) ? id.to_i : id }
    end
  end

  class Compare
    def initialize(version1, version2)
      @version1 = version1
      @version2 = version2
    end

    # :reek:TooManyStatements
    # rubocop:disable Metrics/AbcSize
    def call
      by_major = version1.major <=> version2.major
      return by_major unless by_major.zero?

      by_minor = version1.minor <=> version2.minor
      return by_minor unless by_minor.zero?

      by_patch = version1.patch <=> version2.patch
      return by_patch unless by_patch.zero?

      compare_prereleases(version1.prerelease_identifiers, version2.prerelease_identifiers)
    end
    # rubocop:enable Metrics/AbcSize

    private

    attr_reader :version1, :version2

    # :reek:TooManyStatements
    # :reek:FeatureEnvy
    def compare_prereleases(ids1, ids2)
      # A pre-release version has lower precedence than a normal version
      return 0 if !ids1 && !ids2
      return 1 unless ids1
      return -1 unless ids2

      # Compare pre-release identifiers one-by-one
      each_prerelease_pair(ids1, ids2) do |id1, id2|
        by_prerelease = compare_prerelease(id1, id2)
        return by_prerelease unless by_prerelease.zero?
      end

      0
    end

    # :reek:TooManyStatements
    def compare_prerelease(id1, id2)
      # A larger set of pre-release fields has a higher precedence than a smaller set
      return -1 unless id1
      return 1 unless id2

      id1_is_numeric = id1.is_a?(Integer)
      id2_is_numeric = id2.is_a?(Integer)

      # Numeric identifiers always have lower precedence than non-numeric identifiers.
      return -1 if id1_is_numeric && !id2_is_numeric
      return 1 if !id1_is_numeric && id2_is_numeric

      id1 <=> id2
    end

    # :reek:TooManyStatements
    def each_prerelease_pair(ids1, ids2)
      index = 0

      loop do
        id1 = ids1[index]
        id2 = ids2[index]
        break if !id1 && !id2

        yield(id1, id2)
        index += 1
      end
    end
  end
end
