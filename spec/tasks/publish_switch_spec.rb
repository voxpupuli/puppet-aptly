# frozen_string_literal: true

require 'spec_helper'
require_relative '../fixtures/modules/ruby_task_helper/files/task_helper'
require_relative '../../tasks/publish_switch'

describe AptlyPublishSwitchTask do
  let(:task) { described_class.new }
  let(:opts) { { cli_helper: aptly_helper } }
  let(:aptly_helper) do
    helper = instance_double(Aptly::CliHelper)
    helper
  end

  describe '#task' do
    context 'with single snapshot' do
      let(:opts) { super().merge(distribution: 'bookworm', prefix: 'debian', snapshot: 'example-main-123', architectures: %w[amd64 arm64]) }

      it 'switches to new snapshot' do
        allow(aptly_helper).to receive(:publish_switch).with(opts[:distribution], opts[:prefix], opts[:snapshot], opts).and_return(true)

        result = task.task(opts)
        expect(aptly_helper).to have_received(:publish_switch).once
        expect(result).to eq({ publish_switch: true })
      end
    end

    context 'with multiple snapshots' do
      let(:opts) { super().merge(distribution: 'bookworm', prefix: 'debian', snapshot: %w[example-main-123 example-contrib-123], architectures: %w[amd64 arm64]) }

      it 'switches to new snapshots' do
        allow(aptly_helper).to receive(:publish_switch).with(opts[:distribution], opts[:prefix], opts[:snapshot], opts).and_return(true)

        result = task.task(opts)
        expect(aptly_helper).to have_received(:publish_switch).once
        expect(result).to eq({ publish_switch: true })
      end
    end
  end
end
