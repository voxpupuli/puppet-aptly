# frozen_string_literal: true

require 'spec_helper'
require_relative '../fixtures/modules/ruby_task_helper/files/task_helper'
require_relative '../../tasks/publish_repo'

describe AptlyPublishRepoTask do
  let(:task) { described_class.new }
  let(:opts) { { cli_helper: aptly_helper } }
  let(:aptly_helper) do
    helper = instance_double(PuppetX::Aptly::CliHelper)
    helper
  end

  describe '#task' do
    let(:opts) { super().merge(name: 'example-repo', prefix: 'debian', architectures: %w[amd64 arm64]) }

    it 'publishes the repo' do
      allow(aptly_helper).to receive(:publish_repo).with(opts[:name], opts[:prefix], opts).and_return(true)

      result = task.task(opts)
      expect(aptly_helper).to have_received(:publish_repo).once
      expect(result).to eq({ publish_repo: true })
    end
  end
end
