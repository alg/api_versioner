# frozen_string_literal: true

require 'json'
require 'versioner/default_handler'
require 'versioner/unsupported_version'

RSpec.describe Versioner::DefaultHandler do
  let(:handler) { described_class.new }
  let(:result) { handler.(error, config) }
  let(:status) { result[0] }
  let(:response) { result[2] }
  let(:json) { JSON.parse(response[0]) }

  let(:config) { Versioner::Configuration.new }
  let(:error) { Versioner::UnsupportedVersion.new('message') }
  let(:reason) { nil }

  describe 'HTTP status code' do
    subject(:status) { result[0] }

    it { is_expected.to eq 400 }
  end

  describe 'error details' do
    it 'expects the error details' do
      expect(json['errors'].count).to eq 1

      error = json['errors'][0]
      expect(error['title']).to eq 'message'
      expect(error['status']).to eq 400
      expect(error['code']).to eq 'UNSUPPORTED_VERSION'
    end
  end

  describe 'error meta' do
    subject(:meta) { json.dig('errors', 0, 'meta') }

    context 'when reason given' do
      let(:error) { Versioner::UnsupportedVersion.new('message', reason: 'TOO_LOW') }

      it { is_expected.to eq('reason' => 'TOO_LOW') }
    end

    context 'when reason is not given' do
      it { is_expected.to be_nil }
    end
  end
end
