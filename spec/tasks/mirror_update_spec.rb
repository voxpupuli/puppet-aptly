# frozen_string_literal: true

require 'spec_helper'
require_relative '../fixtures/modules/ruby_task_helper/files/task_helper'
require_relative '../../tasks/mirror_update'

describe AptlyMirrorUpdateTask do
  let(:task) { described_class.new }
  let(:opts) { { cli_helper: aptly_helper } }
  let(:aptly_helper) do
    helper = instance_double(Aptly::CliHelper)
    helper
  end

  describe '#task' do
    let(:opts) { super().merge(name: 'test', architectures: %w[amd64 arm64]) }

    it 'updates the mirror' do
      allow(aptly_helper).to receive(:mirror_update).with(opts[:name], opts).and_return(true)

      result = task.task(opts)
      expect(aptly_helper).to have_received(:mirror_update).once
      expect(result).to eq({ mirror_update: true })
    end
  end
end
