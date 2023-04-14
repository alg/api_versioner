# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ApiVersioner::SemanticVersion do
  let(:valid_versions) do
    [
      '1.0.0',
      '12.45.182',
      '0.0.1-pre.1',
      '1.0.1-pre.5+build.123.5',
      '1.1.1+123',
      '0.0.0+hello',
      '1.2.3-1'
    ]
  end

  let(:invalid_versions) do
    [
      'a.b.c',
      '1.a.3',
      'a.3.4',
      '5.2.a',
      'pre3-1.5.3',
      "I am not a valid semver\n0.0.0\nbut I still pass"
    ]
  end

  describe 'parsing' do
    it 'parses valid versions' do
      valid_versions.each do |version|
        expect { described_class.new(version) }.not_to raise_error
      end
    end

    it 'raises an error on invalid versions' do
      invalid_versions.each do |version|
        expect { described_class.new(version) }.to raise_error(ArgumentError, /not a valid SemVer/)
      end
    end

    it 'parses version correctly' do
      v1 = described_class.new('1.5.9')
      expect(v1.major).to eq(1)
      expect(v1.minor).to eq(5)
      expect(v1.patch).to eq(9)
      expect(v1.pre).to be_nil
      expect(v1.build).to be_nil

      v2 = described_class.new('0.0.1-pre.1')
      expect(v2.major).to eq(0)
      expect(v2.minor).to eq(0)
      expect(v2.patch).to eq(1)
      expect(v2.pre).to eq('pre.1')
      expect(v2.build).to be_nil
      expect(v2.prerelease_identifiers).to eq(['pre', 1])

      v3 = described_class.new('1.0.1-pre.5+build.123.5')
      expect(v3.major).to eq(1)
      expect(v3.minor).to eq(0)
      expect(v3.patch).to eq(1)
      expect(v3.pre).to eq('pre.5')
      expect(v3.build).to eq('build.123.5')
      expect(v3.prerelease_identifiers).to eq(['pre', 5])

      v4 = described_class.new('0.0.0+hello')
      expect(v4.major).to eq(0)
      expect(v4.minor).to eq(0)
      expect(v4.patch).to eq(0)
      expect(v4.pre).to be_nil
      expect(v4.build).to eq('hello')
      expect(v4.prerelease_identifiers).to be_nil
    end
  end

  describe 'comparisons' do
    it 'does not use build metadata to compare versions' do
      ver1 = described_class.new('1.0.0+build1') # build1
      ver2 = described_class.new('1.0.0+build2') # build2
      ver3 = described_class.new('1.0.0')        # no build

      expect(ver1).to eq ver2
      expect(ver2).to eq ver3
    end

    it 'does not use build metadata to compare versions (when pre-release exists)' do
      ver1 = described_class.new('1.0.0-alpha+build1') # build1
      ver2 = described_class.new('1.0.0-alpha+build2') # build2
      ver3 = described_class.new('1.0.0-alpha')        # no build

      expect(ver1).to eq ver2
      expect(ver2).to eq ver3
    end

    it 'place version with more pre-release identifiers higher' do
      ver1 = described_class.new('1.0.0-alpha')
      ver2 = described_class.new('1.0.0-alpha.1')

      expect(ver1).to be < ver2
      expect(ver2).to be > ver1
    end

    it 'compares versions by comparing numeric pre-release identifier' do
      ver1 = described_class.new('1.0.0-1')
      ver2 = described_class.new('1.0.0-2')
      ver3 = described_class.new('1.0.0-10')

      expect(ver1).to be < ver2
      expect(ver2).to be < ver3
    end

    it 'compares versions by comparing numeric identifier (second level)' do
      ver1 = described_class.new('1.0.0-1.1')
      ver2 = described_class.new('1.0.0-1.2')
      ver3 = described_class.new('1.0.0-1.10')

      expect(ver1).to be < ver2
      expect(ver2).to be < ver3
    end

    it 'version with string pre-release identifier are higher than with numeric identifier' do
      ver1 = described_class.new('1.0.0-alpha.1')
      ver2 = described_class.new('1.0.0-alpha.beta')
      expect(ver1).to be < ver2
      expect(ver2).to be > ver1
    end

    it 'sorts versions by comparing string pre-release identifiers' do
      ver1 = described_class.new('1.0.0-alpha')
      ver2 = described_class.new('1.0.0-beta')
      ver3 = described_class.new('1.0.0-rc')
      expect(ver1).to be < ver2
      expect(ver2).to be < ver3
    end

    it 'sorts versions by comparing string pre-release identifiers (second level)' do
      ver1 = described_class.new('1.0.0-alpha.alpha')
      ver2 = described_class.new('1.0.0-alpha.beta')
      ver3 = described_class.new('1.0.0-alpha.rc')

      expect(ver1).to be < ver2
      expect(ver2).to be < ver3
    end

    it 'sorts versions with prelelease lower that without' do
      ver1 = described_class.new('1.0.0')
      ver2 = described_class.new('1.0.0-alpha')

      expect(ver1).to be > ver2
      expect(ver2).to be < ver1
    end

    it 'sorts versions by patch part' do
      ver1 = described_class.new('1.0.1')
      ver2 = described_class.new('1.0.2')
      ver3 = described_class.new('1.0.10')

      expect(ver1).to be < ver2
      expect(ver2).to be < ver3
    end

    it 'sorts versions by minor part' do
      ver1 = described_class.new('1.1.3')
      ver2 = described_class.new('1.2.2')
      ver3 = described_class.new('1.10.1')

      expect(ver1).to be < ver2
      expect(ver2).to be < ver3
    end

    it 'sorts versions by major part' do
      ver1 = described_class.new('1.3.3')
      ver2 = described_class.new('2.2.2')
      ver3 = described_class.new('10.1.1')

      expect(ver1).to be < ver2
      expect(ver2).to be < ver3
    end
  end
end
