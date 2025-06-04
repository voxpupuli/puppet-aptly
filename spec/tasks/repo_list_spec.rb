# frozen_string_literal: true

require 'spec_helper'
require_relative '../fixtures/modules/ruby_task_helper/files/task_helper'
require_relative '../../tasks/repo_list'

describe AptlyRepoListTask do
  let(:task) { described_class.new }
  let(:opts) { { cli_helper: aptly_helper } }
  let(:aptly_helper) do
    helper = instance_double(PuppetX::Aptly::CliHelper)
    helper
  end

  describe '#task' do
    let(:result_json) { [{ 'Name' => 'example-repo' }] }

    it 'lists the repo' do
      allow(aptly_helper).to receive(:repo_list).and_return(result_json)

      result = task.task(opts)
      expect(aptly_helper).to have_received(:repo_list).once
      expect(result).to eq(repo_list: result_json)
    end
  end
end
