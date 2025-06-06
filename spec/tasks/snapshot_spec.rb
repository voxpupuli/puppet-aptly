# frozen_string_literal: true

require 'spec_helper'
require_relative '../fixtures/modules/ruby_task_helper/files/task_helper'
require_relative '../../tasks/snapshot'

describe AptlySnapshotTask do
  let(:task) { described_class.new }
  let(:method_name) { self.class.description } # This defines describe block name as a method_name
  let(:opts) { { _task: "aptly::#{method_name}" } }

  describe 'snapshot_create' do
    # Define method_name explicitly to prevent being overridden in the context blocks below
    let(:method_name) { 'snapshot_create' }

    {
      'mirror' => { name: 'test', from: 'mirror', mirror: 'foo' },
      'repo'   => { name: 'test', from: 'repo', repo: 'foo' },
      'empty'  => { name: 'test', from: 'empty' },
    }.each do |from, options|
      context "from #{from}" do
        let(:opts) { super().merge(options).merge(architectures: %w[amd64 arm64]) }

        it 'creates the snapshot' do
          allow(PuppetX::Aptly::CliHelper).to receive(method_name).with(opts[:name], opts[:from], opts).and_return(true)

          result = task.task(opts)
          expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
          expect(result).to eq({ method_name => true })
        end
      end
    end
  end

  describe 'snapshot_drop' do
    let(:opts) { super().merge(name: 'test') }

    it 'drops the snapshot' do
      allow(PuppetX::Aptly::CliHelper).to receive(method_name).with(opts[:name], opts).and_return(true)

      result = task.task(opts)
      expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
      expect(result).to eq({ method_name => true })
    end
  end

  describe 'snapshot_list' do
    let(:result_json) { [{ 'Name' => 'example-snapshot-123' }] }

    it 'lists snapshots' do
      allow(PuppetX::Aptly::CliHelper).to receive(method_name).with({}).and_return(result_json)

      result = task.task(opts)
      expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
      expect(result).to eq({ method_name => result_json })
    end
  end
end
