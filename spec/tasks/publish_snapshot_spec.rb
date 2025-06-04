# frozen_string_literal: true

require 'spec_helper'
require_relative '../fixtures/modules/ruby_task_helper/files/task_helper'
require_relative '../../tasks/publish_snapshot'

describe AptlyPublishSnapshotTask do
  let(:task) { described_class.new }
  let(:opts) { { cli_helper: aptly_helper } }
  let(:aptly_helper) do
    helper = instance_double(PuppetX::Aptly::CliHelper)
    helper
  end

  describe '#task' do
    context 'with single snapshot' do
      let(:opts) { super().merge(name: 'example-snapshot-123', prefix: 'debian', architectures: %w[amd64 arm64]) }

      it 'publishes the snapshot' do
        allow(aptly_helper).to receive(:publish_snapshot).with(opts[:name], opts[:prefix], opts).and_return(true)

        result = task.task(opts)
        expect(aptly_helper).to have_received(:publish_snapshot).once
        expect(result).to eq({ publish_snapshot: true })
      end
    end

    context 'with multiple snapshots' do
      let(:opts) { super().merge(name: %w[example-main-123 example-contrib-123], prefix: 'debian', architectures: %w[amd64 arm64]) }

      it 'publishes the snapshots' do
        allow(aptly_helper).to receive(:publish_snapshot).with(opts[:name], opts[:prefix], opts).and_return(true)

        result = task.task(opts)
        expect(aptly_helper).to have_received(:publish_snapshot).once
        expect(result).to eq({ publish_snapshot: true })
      end
    end
  end
end
