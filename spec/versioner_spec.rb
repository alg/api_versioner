# frozen_string_literal: true

RSpec.describe Versioner do
  it 'has a version number' do
    expect(Versioner::VERSION).not_to be nil
  end

  describe 'configuration' do
    subject(:config) { described_class.config }

    context 'when default' do
      it { expect(config.current_version).to be_nil }
      it { expect(config.server_version_header).to eq 'X-API-SERVER-VERSION' }
      it { expect(config.client_version_header).to eq 'X-API-CLIENT-VERSION' }
    end

    context 'when overriden' do
      before do
        described_class.configure do |c|
          c.current_version = '1.2.3'
          c.server_version_header = 'X-SVER'
          c.client_version_header = 'X-CVER'
        end
      end

      it { expect(config.current_version).to eq '1.2.3' }
      it { expect(config.server_version_header).to eq 'X-SVER' }
      it { expect(config.client_version_header).to eq 'X-CVER' }
    end
  end
end
