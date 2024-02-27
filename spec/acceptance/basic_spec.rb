# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'aptly class' do
  context 'default parameters' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        include apt
        include aptly
        PUPPET
      end
    end
  end
end
