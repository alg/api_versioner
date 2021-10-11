# frozen_string_literal: true

require 'rack'
require 'versioner/server_version_middleware'

RSpec.describe Versioner::ServerVersionMiddleware do
  subject(:middleware) { described_class.new(app, config) }

  let(:app) { double('app', call: app_result) } # rubocop:disable RSpec/VerifiedDoubles
  let(:config) { Versioner::Configuration.new }
  let(:env) { {} }

  let(:app_result) { [status, headers, response] }
  let(:status) { 200 }
  let(:headers) { {} }
  let(:response) { 'body' }

  let(:server_version_header) { 'X-VER' }
  let(:current_version) { '1.2.3' }

  before do
    config.server_version_header = server_version_header
    config.current_version = current_version
  end

  context 'when header and version are given' do
    it 'adds header to the response' do
      _status, headers, _response = middleware.(env)
      expect(headers['X-VER']).to eq '1.2.3'
    end
  end

  context 'when header is unspecified' do
    let(:server_version_header) { nil }

    it 'does not add header to the response' do
      _status, headers, _response = middleware.(env)
      expect(headers).to be_empty
    end
  end

  context 'when version is unspecified' do
    let(:current_version) { nil }

    it 'does not add header to the response' do
      _status, headers, _response = middleware.(env)
      expect(headers).to be_empty
    end
  end
end
