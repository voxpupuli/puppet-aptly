# frozen_string_literal: true

require 'spec_helper'
require_relative '../fixtures/modules/ruby_task_helper/files/task_helper'
require_relative '../../tasks/publish_update'

describe AptlyPublishUpdateTask do
  let(:task) { described_class.new }
  let(:opts) { { cli_helper: aptly_helper } }
  let(:aptly_helper) do
    helper = instance_double(PuppetX::Aptly::CliHelper)
    helper
  end

  describe '#task' do
    let(:opts) { super().merge(distribution: 'bookworm', prefix: 'debian', architectures: %w[amd64 arm64]) }

    it 'updates the published repo' do
      allow(aptly_helper).to receive(:publish_update).with(opts[:distribution], opts[:prefix], opts).and_return(true)

      result = task.task(opts)
      expect(aptly_helper).to have_received(:publish_update).once
      expect(result).to eq({ publish_update: true })
    end
  end
end
