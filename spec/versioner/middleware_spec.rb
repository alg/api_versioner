# frozen_string_literal: true

require 'versioner/middleware'

RSpec.describe Versioner::Middleware do
  subject(:middleware) { described_class.new(app, config) }

  let(:app) { double('app', call: app_result) } # rubocop:disable RSpec/VerifiedDoubles
  let(:config) { Versioner::Configuration.new }
  let(:env) { {} }

  let(:app_result) { [status, headers, response] }
  let(:status) { 200 }
  let(:headers) { {} }
  let(:response) { 'body' }

  let(:header_name) { 'X-VER' }
  let(:current_version) { '1.2.3' }

  before do
    config.header_name = header_name
    config.current_version = current_version
  end

  context 'when header and version are given' do
    it 'adds header to the response' do
      _status, headers, _response = middleware.(env)
      expect(headers['X-VER']).to eq '1.2.3'
    end
  end

  [' ', nil].each do |val|
    context "when header is '#{val}'" do
      let(:header_name) { val }

      it 'does not add header to the response' do
        _status, headers, _response = middleware.(env)
        expect(headers).to be_empty
      end
    end
  end

  [' ', nil].each do |val|
    context "when version is '#{val}'" do
      let(:current_version) { val }

      it 'does not add header to the response' do
        _status, headers, _response = middleware.(env)
        expect(headers).to be_empty
      end
    end
  end
end
