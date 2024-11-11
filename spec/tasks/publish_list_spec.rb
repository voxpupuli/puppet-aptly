# frozen_string_literal: true

require 'spec_helper'
require_relative '../fixtures/modules/ruby_task_helper/files/task_helper'
require_relative '../../tasks/publish_list'

describe AptlyPublishListTask do
  let(:task) { described_class.new }
  let(:opts) { { cli_helper: aptly_helper } }
  let(:aptly_helper) do
    helper = instance_double(Aptly::CliHelper)
    helper
  end

  describe '#task' do
    let(:result_json) { [{ 'Distribution' => 'bookworm', 'Prefix' => 'current/debian' }] }

    it 'lists the publish' do
      allow(aptly_helper).to receive(:publish_list).and_return(result_json)

      result = task.task(opts)
      expect(aptly_helper).to have_received(:publish_list).once
      expect(result).to eq(publish_list: result_json)
    end
  end
end
