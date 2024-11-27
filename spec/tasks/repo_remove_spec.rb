# frozen_string_literal: true

require 'spec_helper'
require_relative '../fixtures/modules/ruby_task_helper/files/task_helper'
require_relative '../../tasks/repo_remove'

describe AptlyRepoRemoveTask do
  let(:task) { described_class.new }
  let(:opts) { { cli_helper: aptly_helper } }
  let(:aptly_helper) do
    helper = instance_double(Aptly::CliHelper)
    helper
  end

  describe '#task' do
    let(:opts) { super().merge(name: 'example-repo', package_query: 'foo') }

    it 'removes package to the repo' do
      allow(aptly_helper).to receive(:repo_remove).with(opts[:name], opts[:package_query], opts).and_return(true)

      result = task.task(opts)
      expect(aptly_helper).to have_received(:repo_remove).once
      expect(result).to eq({ repo_remove: true })
    end
  end
end
