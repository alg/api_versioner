# frozen_string_literal: true

require 'semantic'
require 'versioner/default_policy'
require 'versioner/incompatible_version'

RSpec.describe Versioner::DefaultPolicy do
  subject(:check) { described_class.new.(current_version, requested_version) }

  let(:current_version) { version('2.3.4') }

  def version(str)
    Semantic::Version.new(str)
  end

  context 'when requested version is unspecified' do
    let(:requested_version) { nil }

    it { expect { check }.not_to raise_error }
  end

  context 'when requested version differs on major level' do
    let(:requested_version) { version('1.3.4') }

    it { expect { check }.to raise_error Versioner::IncompatibleVersion }
  end

  context 'when requested version differs on minor level' do
    let(:requested_version) { version('2.1.4') }

    it { expect { check }.not_to raise_error }
  end

  context 'when requested version differs on patch level' do
    let(:requested_version) { version('2.3.1') }

    it { expect { check }.not_to raise_error }
  end

  context 'when requested version is greater' do
    let(:requested_version) { version('2.3.5') }

    it { expect { check }.to raise_error Versioner::IncompatibleVersion }
  end
end
