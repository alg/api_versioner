# frozen_string_literal: true

require 'rack'
require 'versioner/client_version_middleware'
require 'versioner/default_handler'
require 'versioner/incompatible_version'

RSpec.describe Versioner::ClientVersionMiddleware do
  subject(:middleware) { described_class.new(app, config) }

  let(:app) { double('app', call: app_result) } # rubocop:disable RSpec/VerifiedDoubles
  let(:config) { Versioner::Configuration.new }
  let(:env) { {} }

  let(:app_result) { [status, headers, response] }
  let(:status) { 200 }
  let(:headers) { {} }
  let(:response) { 'body' }

  let(:client_version_header) { 'X-VER' }
  let(:http_client_version_header) { 'HTTP_X_VER' }
  let(:current_version) { Semantic::Version.new('1.2.3') }
  let(:policy) { instance_double(Versioner::DefaultPolicy, call: nil) }
  let(:handler) { instance_double(Versioner::DefaultHandler, call: :handler_response) }

  before do
    config.client_version_header = client_version_header
    config.current_version = current_version.to_s
    config.version_policy = policy
    config.incompatible_version_handler = handler
  end

  context 'when not checking versions' do
    let(:client_version_header) { nil }

    it 'calls the app and returns the info' do
      ret_status, ret_headers, ret_response = middleware.(env)

      expect(ret_status).to eq status
      expect(ret_headers).to eq headers
      expect(ret_response).to eq response
      expect(policy).not_to have_received(:call)
      expect(app).to have_received(:call)
    end
  end

  context 'when client version is not given' do
    before { env[http_client_version_header] = nil }

    it 'sends it to policy as nil' do
      middleware.(env)
      expect(policy).to have_received(:call).with(current_version, nil)
    end
  end

  context 'when client version is empty' do
    before { env[http_client_version_header] = ' ' }

    it 'sends it to policy as nil' do
      middleware.(env)
      expect(policy).to have_received(:call).with(current_version, nil)
    end
  end

  context 'when client version is invalid' do
    before { env[http_client_version_header] = 'a.b.c' }

    it 'sends it to policy as nil' do
      middleware.(env)
      expect(policy).to have_received(:call).with(current_version, nil)
    end
  end

  context 'when checking versions' do
    let(:client_version) { Semantic::Version.new('1.2.2') }

    before { env[http_client_version_header] = client_version.to_s }

    context 'when version is ok' do
      it 'returns the app result' do
        expect(middleware.(env)).to eq app_result
        expect(policy).to have_received(:call).with(current_version, client_version)
      end
    end

    context 'when version is incompatible' do
      let(:error) { Versioner::IncompatibleVersion.new }

      before { allow(policy).to receive(:call).and_raise(error) }

      it 'handles the error' do
        expect(middleware.(env)).to eq :handler_response
        expect(handler).to have_received(:call).with(error, config)
      end
    end
  end
end
