# frozen_string_literal: true

require 'json'
require 'versioner/default_handler'
require 'versioner/incompatible_version'

RSpec.describe Versioner::DefaultHandler do
  subject(:handler) { described_class.new }

  let(:config) { Versioner::Configuration.new }
  let(:error) { Versioner::IncompatibleVersion.new('message') }

  it 'sets the correct status' do
    status, _headers, _response = handler.(error, config)

    expect(status).to eq 400
  end

  it 'returns the JSON with an error' do
    _status, _headers, response = handler.(error, config)

    expect(JSON.parse(response[0])).to eq(
      'errors' => [
        {
          'title' => 'message',
          'status' => 400,
          'code' => 'UNSUPPORTED_VERSION'
        }
      ]
    )
  end
end
