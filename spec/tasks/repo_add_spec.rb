# frozen_string_literal: true

require 'spec_helper'
require_relative '../fixtures/modules/ruby_task_helper/files/task_helper'
require_relative '../../tasks/repo_add'

describe AptlyRepoAddTask do
  let(:task) { described_class.new }
  let(:opts) { { cli_helper: aptly_helper } }
  let(:aptly_helper) do
    helper = instance_double(Aptly::CliHelper)
    helper
  end

  describe '#task' do
    context 'with package specified' do
      let(:opts) { super().merge(name: 'example-repo', package: 'foo') }

      it 'adds package to the repo' do
        allow(aptly_helper).to receive(:repo_add).with(opts[:name], opts[:package], opts).and_return(true)

        result = task.task(opts)
        expect(aptly_helper).to have_received(:repo_add).once
        expect(result).to eq({ repo_add: true })
      end
    end

    context 'with directory specified' do
      let(:opts) { super().merge(name: 'example-repo', directory: 'bar') }

      it 'adds package to the repo' do
        allow(aptly_helper).to receive(:repo_add).with(opts[:name], opts[:directory], opts).and_return(true)

        result = task.task(opts)
        expect(aptly_helper).to have_received(:repo_add).once
        expect(result).to eq({ repo_add: true })
      end
    end

    context 'with both package and directory specified' do
      let(:opts) { super().merge(name: 'example-repo', package: 'foo', directory: 'bar') }

      specify do
        expect { task.task(opts) }.to raise_error(an_instance_of(TaskHelper::Error).and(having_attributes(kind: 'aptly/repo-add-error')))
      end
    end

    context 'without package and directory specified' do
      let(:opts) { super().merge(name: 'example-repo') }

      specify do
        expect { task.task(opts) }.to raise_error(an_instance_of(TaskHelper::Error).and(having_attributes(kind: 'aptly/repo-add-error')))
      end
    end
  end
end
