# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/aptly_mirror'

describe 'the aptly_mirror type' do
  it 'loads' do
    expect(Puppet::Type.type(:aptly_mirror)).not_to be_nil
  end
end
