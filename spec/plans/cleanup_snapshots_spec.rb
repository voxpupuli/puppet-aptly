# frozen_string_literal: true

require 'spec_helper'

describe 'aptly::cleanup_snapshots' do
  let(:plan) { 'aptly::cleanup_snapshots' }

  context 'with single target' do
    let(:plan_targets) { 'aptly1' }
    let(:publish_list) do
      [
        { 'SourceKind' => 'snapshot', 'Sources' => ['Name' => 'foo-234'] },
        { 'Sources' => ['Name' => 'baz-123'] },
      ]
    end
    let(:snapshot_list) do
      [
        { 'Name' => 'foo-123' },
        { 'Name' => 'foo-234' },
        { 'Name' => 'baz-123' },
      ]
    end

    before do
      expect_task('aptly::publish_list').
        with_targets(plan_targets).
        always_return({ 'publish_list' => publish_list })

      expect_task('aptly::snapshot_list').
        with_targets(plan_targets).
        always_return({ 'snapshot_list' => snapshot_list })
    end

    context 'without filter' do
      it 'runs successfully' do
        # Drop 'foo-123' (not in publish_list)
        # Drop 'baz-123' (SourceKind != 'snapshot')
        %w[foo-123 baz-123].each do |snapshot|
          expect_task('aptly::snapshot_drop').
            with_targets(plan_targets).
            with_params('name' => snapshot).
            always_return({ 'snapshot_drop' => true })
        end

        result = run_plan(plan, 'targets' => plan_targets)
        expect(result.ok?).to be(true)
        expect(result.value.length).to eq(2)
      end
    end

    context 'with filter' do
      it 'runs successfully' do
        filter = '^foo-.*'

        # Drop 'foo-123' (matches filter, not in publish_list)
        expect_task('aptly::snapshot_drop').
          with_targets(plan_targets).
          with_params('name' => 'foo-123').
          always_return({ 'snapshot_drop' => true })

        result = run_plan(plan, 'targets' => plan_targets, 'filter' => filter)
        expect(result.ok?).to be(true)
        expect(result.value.length).to eq(1)
      end
    end

    context 'with noop' do
      it 'runs successfully' do
        %w[foo-123 baz-123].each do |snapshot|
          expect_out_verbose.with_params("Deleting snapshot #{snapshot}...")
        end
        result = run_plan(plan, 'targets' => plan_targets, 'noop' => true)
        expect(result.ok?).to be(true)
        expect(result.value.length).to eq(2)
      end
    end
  end

  context 'with multiple targets' do
    let(:plan_targets) { %w[aptly1 aptly2] }

    it 'returns too-many-targets' do
      result = run_plan(plan, 'targets' => plan_targets)
      expect(result.ok?).to be(false)
      expect(result.value).to be_a(Bolt::PlanFailure)
      expect(result.value.kind).to eq('aptly::cleanup_snapshots/too-many-targets')
      expect(result.value.details['count']).to eq(2)
    end
  end
end
