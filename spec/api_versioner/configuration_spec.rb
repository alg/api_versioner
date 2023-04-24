# frozen_string_literal: true

require 'api_versioner/configuration'

RSpec.describe ApiVersioner::Configuration do
  subject(:config) { described_class.new }

  describe '#current_version' do
    subject(:current_version) { config.current_version }

    it { is_expected.to be_nil }

    it 'converts textual version into object' do
      config.current_version = '1.2.3'

      expect(current_version).to be_a ApiVersioner::SemanticVersion
      expect(current_version.to_s).to eq '1.2.3'
    end
  end

  describe '#server_version_header' do
    subject(:name) { config.server_version_header }

    it { is_expected.to eq described_class::DEFAULT_SERVER_VERSION_HEADER }

    it 'converts the value' do
      config.server_version_header = '  X-HEAD '

      expect(name).to eq 'X-HEAD'
    end

    it 'does converts the empty value to nil' do
      config.server_version_header = ' '

      expect(name).to be_nil
    end
  end

  describe '#client_version_header' do
    subject(:name) { config.client_version_header }

    it { is_expected.to eq described_class::DEFAULT_CLIENT_VERSION_HEADER }

    it 'converts the value' do
      config.client_version_header = '  X-HEAD '

      expect(name).to eq 'X-HEAD'
    end

    it 'does converts the empty value to nil' do
      config.client_version_header = ' '

      expect(name).to be_nil
    end
  end

  describe '#version_policy' do
    subject(:policy) { config.version_policy }

    it { is_expected.to be_a ApiVersioner::DefaultPolicy }

    it 'sets the policy' do
      config.version_policy = :policy

      expect(policy).to eq :policy
    end

    it 'allows to set nil policy' do
      config.version_policy = nil

      expect(policy).to be_nil
    end
  end

  describe '#unsupported_version_handler' do
    subject(:handler) { config.unsupported_version_handler }

    it { is_expected.to be_a ApiVersioner::DefaultHandler }

    it 'sets the handler' do
      config.unsupported_version_handler = :handler

      expect(handler).to eq :handler
    end

    it 'allows to set nil handler' do
      config.unsupported_version_handler = nil
      expect(handler).to be_nil
    end
  end
end
