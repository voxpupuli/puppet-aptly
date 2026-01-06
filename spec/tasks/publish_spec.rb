# frozen_string_literal: true

require 'spec_helper'
require_relative '../fixtures/modules/ruby_task_helper/files/task_helper'
require_relative '../../tasks/publish'

describe AptlyPublishTask do
  let(:task) { described_class.new }
  let(:method_name) { self.class.description } # This defines describe block name as a method_name
  let(:opts) { { _task: "aptly::#{method_name}" } }

  describe 'publish_drop' do
    let(:opts) { super().merge(distribution: 'bookworm', prefix: 'debian') }

    it 'drops the published repository' do
      allow(PuppetX::Aptly::CliHelper).to receive(method_name).with(opts[:distribution], opts[:prefix], opts).and_return(true)

      result = task.task(opts)
      expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
      expect(result).to eq({ method_name => true })
    end
  end

  describe 'publish_show' do
    let(:result_json) { { 'Distribution' => 'bookworm', 'Prefix' => 'current/debian' } }
    let(:opts) { super().merge(distribution: 'bookworm', prefix: 'debian') }

    it 'shows the published repository' do
      allow(PuppetX::Aptly::CliHelper).to receive(method_name).with(opts[:distribution], opts[:prefix], opts).and_return(result_json)

      result = task.task(opts)
      expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
      expect(result).to eq({ method_name => result_json })
    end
  end

  describe 'publish_list' do
    let(:result_json) { [{ 'Distribution' => 'bookworm', 'Prefix' => 'current/debian' }] }

    it 'lists published repositories' do
      allow(PuppetX::Aptly::CliHelper).to receive(method_name).with({}).and_return(result_json)

      result = task.task(opts)
      expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
      expect(result).to eq({ method_name => result_json })
    end
  end

  describe 'publish_repo' do
    let(:opts) { super().merge(name: 'example-repo', prefix: 'debian', architectures: %w[amd64 arm64]) }

    it 'publishes the repository' do
      allow(PuppetX::Aptly::CliHelper).to receive(method_name).with(opts[:name], opts[:prefix], opts).and_return(true)

      result = task.task(opts)
      expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
      expect(result).to eq({ method_name => true })
    end
  end

  describe 'publish_snapshot' do
    # Define method_name explicitly to prevent being overridden in the context blocks below
    let(:method_name) { 'publish_snapshot' }

    context 'with single snapshot' do
      let(:opts) { super().merge(name: 'example-snapshot-123', prefix: 'debian', architectures: %w[amd64 arm64]) }

      it 'publishes the snapshot' do
        allow(PuppetX::Aptly::CliHelper).to receive(method_name).with(opts[:name], opts[:prefix], opts).and_return(true)

        result = task.task(opts)
        expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
        expect(result).to eq({ method_name => true })
      end
    end

    context 'with multiple snapshots' do
      let(:opts) { super().merge(name: %w[example-main-123 example-contrib-123], prefix: 'debian', architectures: %w[amd64 arm64]) }

      it 'publishes the snapshot' do
        allow(PuppetX::Aptly::CliHelper).to receive(method_name).with(opts[:name], opts[:prefix], opts).and_return(true)

        result = task.task(opts)
        expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
        expect(result).to eq({ method_name => true })
      end
    end
  end

  describe 'publish_switch' do
    # Define method_name explicitly to prevent being overridden in the context blocks below
    let(:method_name) { 'publish_switch' }

    context 'with single snapshot' do
      let(:opts) { super().merge(distribution: 'bookworm', prefix: 'debian', snapshot: 'example-main-123', architectures: %w[amd64 arm64]) }

      it 'switches to new snapshot' do
        allow(PuppetX::Aptly::CliHelper).to receive(method_name).with(opts[:distribution], opts[:prefix], opts[:snapshot], opts).and_return(true)

        result = task.task(opts)
        expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
        expect(result).to eq({ method_name => true })
      end
    end

    context 'with multiple snapshots' do
      let(:opts) { super().merge(distribution: 'bookworm', prefix: 'debian', snapshot: %w[example-main-123 example-contrib-123], architectures: %w[amd64 arm64]) }

      it 'switches to new snapshot' do
        allow(PuppetX::Aptly::CliHelper).to receive(method_name).with(opts[:distribution], opts[:prefix], opts[:snapshot], opts).and_return(true)

        result = task.task(opts)
        expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
        expect(result).to eq({ method_name => true })
      end
    end
  end

  describe 'publish_update' do
    let(:opts) { super().merge(distribution: 'bookworm', prefix: 'debian', architectures: %w[amd64 arm64]) }

    it 'updates the published repo' do
      allow(PuppetX::Aptly::CliHelper).to receive(method_name).with(opts[:distribution], opts[:prefix], opts).and_return(true)

      result = task.task(opts)
      expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
      expect(result).to eq({ method_name => true })
    end
  end
end
