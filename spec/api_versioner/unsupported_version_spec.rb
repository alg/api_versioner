# frozen_string_literal: true

require 'api_versioner/unsupported_version'

RSpec.describe ApiVersioner::UnsupportedVersion do
  it 'initializes without message' do
    error = described_class.new

    expect(error.message).to eq described_class.name
    expect(error.reason).to be_nil
  end

  it 'records the reason' do
    error = described_class.new(reason: 'reason')

    expect(error.reason).to eq 'reason'
  end

  it 'records the message' do
    error = described_class.new('message')

    expect(error.message).to eq 'message'
  end
end
