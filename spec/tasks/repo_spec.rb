# frozen_string_literal: true

require 'spec_helper'
require_relative '../fixtures/modules/ruby_task_helper/files/task_helper'
require_relative '../../tasks/repo'

describe AptlyRepoTask do
  let(:task) { described_class.new }
  let(:method_name) { self.class.description } # This defines describe block name as a method_name
  let(:opts) { { _task: "aptly::#{method_name}" } }

  describe 'repo_add' do
    # Define method_name explicitly to prevent being overridden in the context blocks below
    let(:method_name) { 'repo_add' }

    context 'with package specified' do
      let(:opts) { super().merge(name: 'example-repo', package: 'foo') }

      it 'adds package to the repo' do
        allow(PuppetX::Aptly::CliHelper).to receive(method_name).with(opts[:name], opts[:package], opts).and_return(true)

        result = task.task(opts)
        expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
        expect(result).to eq({ method_name => true })
      end
    end

    context 'with directory specified' do
      let(:opts) { super().merge(name: 'example-repo', directory: 'bar') }

      it 'adds package to the repo' do
        allow(PuppetX::Aptly::CliHelper).to receive(method_name).with(opts[:name], opts[:directory], opts).and_return(true)

        result = task.task(opts)
        expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
        expect(result).to eq({ method_name => true })
      end
    end

    context 'with both package and directory specified' do
      let(:opts) { super().merge(name: 'example-repo', package: 'foo', directory: 'bar') }

      specify do
        expect { task.task(opts) }.to raise_error(an_instance_of(TaskHelper::Error).and(having_attributes(kind: 'aptly/repo_add-error')))
      end
    end

    context 'without package and directory specified' do
      let(:opts) { super().merge(name: 'example-repo') }

      specify do
        expect { task.task(opts) }.to raise_error(an_instance_of(TaskHelper::Error).and(having_attributes(kind: 'aptly/repo_add-error')))
      end
    end
  end

  describe 'repo_create' do
    # Define method_name explicitly to prevent being overridden in the context blocks below
    let(:method_name) { 'repo_create' }
    let(:opts) { super().merge(name: 'test', architectures: %w[amd64 arm64]) }

    it 'creates the repo' do
      allow(PuppetX::Aptly::CliHelper).to receive(method_name).with(opts[:name], opts).and_return(true)

      result = task.task(opts)
      expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
      expect(result).to eq({ method_name => true })
    end

    context 'from snapshot' do
      let(:opts) { super().merge(snapshot: 'example-snapshot-123') }

      it 'creates the repo' do
        allow(PuppetX::Aptly::CliHelper).to receive(method_name).with(opts[:name], opts).and_return(true)

        result = task.task(opts)
        expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
        expect(result).to eq({ method_name => true })
      end
    end
  end

  describe 'repo_drop' do
    let(:opts) { super().merge(name: 'test') }

    it 'drops the repo' do
      allow(PuppetX::Aptly::CliHelper).to receive(method_name).with(opts[:name], opts).and_return(true)

      result = task.task(opts)
      expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
      expect(result).to eq({ method_name => true })
    end
  end

  describe 'repo_list' do
    let(:result_json) { [{ 'Name' => 'example-repo' }] }

    it 'lists repos' do
      allow(PuppetX::Aptly::CliHelper).to receive(method_name).with({}).and_return(result_json)

      result = task.task(opts)
      expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
      expect(result).to eq({ method_name => result_json })
    end
  end

  describe 'repo_remove' do
    let(:opts) { super().merge(name: 'example-repo', package_query: 'foo') }

    it 'removes package to the repo' do
      allow(PuppetX::Aptly::CliHelper).to receive(method_name).with(opts[:name], opts[:package_query], opts).and_return(true)

      result = task.task(opts)
      expect(PuppetX::Aptly::CliHelper).to have_received(method_name).once
      expect(result).to eq({ method_name => true })
    end
  end
end
