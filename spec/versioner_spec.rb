# frozen_string_literal: true

RSpec.describe Versioner do
  it 'has a version number' do
    expect(Versioner::VERSION).not_to be nil
  end

  describe 'configuration' do
    subject(:config) { Versioner.config }

    context 'when default' do
      it { expect(config.current_version).to be_nil }
      it { expect(config.header_name).to eq 'X-API-SERVER-VERSION' }
    end

    context 'when overriden' do
      before do
        Versioner.configure do |c|
          c.current_version = '1.2.3'
          c.header_name = 'X-VER'
        end
      end

      it { expect(config.current_version).to eq '1.2.3' }
      it { expect(config.header_name).to eq 'X-VER' }
    end
  end
end
