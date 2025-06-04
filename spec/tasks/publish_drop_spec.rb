# frozen_string_literal: true

require 'spec_helper'
require_relative '../fixtures/modules/ruby_task_helper/files/task_helper'
require_relative '../../tasks/publish_drop'

describe AptlyPublishDropTask do
  let(:task) { described_class.new }
  let(:opts) { { cli_helper: aptly_helper } }
  let(:aptly_helper) do
    helper = instance_double(PuppetX::Aptly::CliHelper)
    helper
  end

  describe '#task' do
    let(:opts) { super().merge(distribution: 'bookworm', prefix: 'debian') }

    it 'dropes to new snapshot' do
      allow(aptly_helper).to receive(:publish_drop).with(opts[:distribution], opts[:prefix], opts).and_return(true)

      result = task.task(opts)
      expect(aptly_helper).to have_received(:publish_drop).once
      expect(result).to eq({ publish_drop: true })
    end
  end
end
