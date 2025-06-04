# frozen_string_literal: true

require 'spec_helper'
require_relative '../fixtures/modules/ruby_task_helper/files/task_helper'
require_relative '../../tasks/snapshot_drop'

describe AptlySnapshotDropTask do
  let(:task) { described_class.new }
  let(:opts) { { cli_helper: aptly_helper } }
  let(:aptly_helper) do
    helper = instance_double(PuppetX::Aptly::CliHelper)
    helper
  end

  describe '#task' do
    let(:opts) { super().merge(name: 'test') }

    it 'drops the snapshot' do
      allow(aptly_helper).to receive(:snapshot_drop).with(opts[:name], opts).and_return(true)

      result = task.task(opts)
      expect(aptly_helper).to have_received(:snapshot_drop).once
      expect(result).to eq({ snapshot_drop: true })
    end
  end
end
