# frozen_string_literal: true

require 'spec_helper'
require_relative '../fixtures/modules/ruby_task_helper/files/task_helper'
require_relative '../../tasks/mirror_create'

describe AptlyMirrorCreateTask do
  let(:task) { described_class.new }
  let(:opts) { { cli_helper: aptly_helper } }
  let(:aptly_helper) do
    helper = instance_double(Aptly::CliHelper)
    helper
  end

  describe '#task' do
    let(:opts) { super().merge(name: 'test', url: 'https://deb.debian.org/debian/', distribution: 'bookworm', architectures: %w[amd64 arm64]) }

    it 'creates the mirror' do
      allow(aptly_helper).to receive(:mirror_create).with(opts[:name], opts[:url], opts[:distribution], opts).and_return(true)

      result = task.task(opts)
      expect(aptly_helper).to have_received(:mirror_create).once
      expect(result).to eq({ mirror_create: true })
    end
  end
end
