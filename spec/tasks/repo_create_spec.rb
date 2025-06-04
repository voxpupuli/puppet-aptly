# frozen_string_literal: true

require 'spec_helper'
require_relative '../fixtures/modules/ruby_task_helper/files/task_helper'
require_relative '../../tasks/repo_create'

describe AptlyRepoCreateTask do
  let(:task) { described_class.new }
  let(:opts) { { cli_helper: aptly_helper } }
  let(:aptly_helper) do
    helper = instance_double(PuppetX::Aptly::CliHelper)
    helper
  end

  describe '#task' do
    let(:opts) { super().merge(name: 'test', architectures: %w[amd64 arm64]) }

    it 'creates the repo' do
      allow(aptly_helper).to receive(:repo_create).with(opts[:name], opts).and_return(true)

      result = task.task(opts)
      expect(aptly_helper).to have_received(:repo_create).once
      expect(result).to eq({ repo_create: true })
    end

    context 'from snapshot' do
      let(:opts) { super().merge(snapshot: 'example-snapshot-123') }

      it 'creates the repo' do
        allow(aptly_helper).to receive(:repo_create).with(opts[:name], opts).and_return(true)

        result = task.task(opts)
        expect(aptly_helper).to have_received(:repo_create).once
        expect(result).to eq({ repo_create: true })
      end
    end
  end
end
