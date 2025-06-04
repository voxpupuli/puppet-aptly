# frozen_string_literal: true

require 'spec_helper'
require_relative '../fixtures/modules/ruby_task_helper/files/task_helper'
require_relative '../../tasks/snapshot_create'

describe AptlySnapshotCreateTask do
  let(:task) { described_class.new }
  let(:opts) { { cli_helper: aptly_helper } }
  let(:aptly_helper) do
    helper = instance_double(PuppetX::Aptly::CliHelper)
    helper
  end

  describe '#task' do
    {
      'mirror' => { name: 'test', from: 'mirror', mirror: 'foo' },
      'repo'   => { name: 'test', from: 'repo', repo: 'foo' },
      'empty'  => { name: 'test', from: 'emtpy' },
    }.each do |from, options|
      context "from #{from}" do
        let(:opts) { super().merge(options).merge(architectures: %w[amd64 arm64]) }

        it 'creates the snapshot' do
          allow(aptly_helper).to receive(:snapshot_create).with(opts[:name], opts[:from], opts).and_return(true)

          result = task.task(opts)
          expect(aptly_helper).to have_received(:snapshot_create).once
          expect(result).to eq({ snapshot_create: true })
        end
      end
    end
  end
end
