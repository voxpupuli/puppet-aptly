# frozen_string_literal: true

require 'spec_helper'
require_relative '../fixtures/modules/ruby_task_helper/files/task_helper'
require_relative '../../tasks/mirror_list'

describe AptlyMirrorListTask do
  let(:task) { described_class.new }
  let(:opts) { { cli_helper: aptly_helper } }
  let(:aptly_helper) do
    helper = instance_double(PuppetX::Aptly::CliHelper)
    helper
  end

  describe '#task' do
    let(:result_json) { [{ 'Name' => 'bookworm-main' }] }

    it 'lists the mirror' do
      allow(aptly_helper).to receive(:mirror_list).and_return(result_json)

      result = task.task(opts)
      expect(aptly_helper).to have_received(:mirror_list).once
      expect(result).to eq(mirror_list: result_json)
    end
  end
end
