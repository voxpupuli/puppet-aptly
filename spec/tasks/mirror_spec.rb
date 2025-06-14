# frozen_string_literal: true

require 'spec_helper'
require_relative '../fixtures/modules/ruby_task_helper/files/task_helper'
require_relative '../../tasks/mirror'

describe AptlyMirrorTask do
  let(:task) { described_class.new }
  let(:method_name) { self.class.description } # This defines describe block name as a method_name
  let(:opts) { { _task: "aptly::#{method_name}" } }

  describe 'mirror_create' do
    let(:opts) do
      super().merge(
        name: 'test',
        url: 'https://deb.debian.org/debian/',
        distribution: 'bookworm',
        architectures: %w[amd64 arm64]
      )
    end

    it 'creates the mirror' do
      allow(PuppetX::Aptly::CliHelper).to receive(method_name).with(opts[:name], opts[:url], opts[:distribution], opts).and_return(true)

      result = task.task(opts)
      expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
      expect(result).to eq({ method_name => true })
    end
  end

  describe 'mirror_drop' do
    let(:opts) { super().merge(name: 'test') }

    it 'drops the mirror' do
      allow(PuppetX::Aptly::CliHelper).to receive(method_name).with(opts[:name], opts).and_return(true)

      result = task.task(opts)
      expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
      expect(result).to eq({ method_name => true })
    end
  end

  describe 'mirror_list' do
    let(:result_json) { [{ 'Name' => 'bookworm-main' }] }

    it 'lists mirrors' do
      allow(PuppetX::Aptly::CliHelper).to receive(method_name).with({}).and_return(result_json)

      result = task.task(opts)
      expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
      expect(result).to eq({ method_name => result_json })
    end
  end

  describe 'mirror_update' do
    let(:opts) { super().merge(name: 'test', architectures: %w[amd64 arm64]) }

    it 'updates the mirror' do
      allow(PuppetX::Aptly::CliHelper).to receive(method_name).with(opts[:name], opts).and_return(true)

      result = task.task(opts)
      expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
      expect(result).to eq({ method_name => true })
    end
  end
end
