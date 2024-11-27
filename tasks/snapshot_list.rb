#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/cli_helper'
require_relative '../../ruby_task_helper/files/task_helper' unless Object.const_defined?('TaskHelper')

# List snapshots
class AptlySnapshotListTask < TaskHelper
  def task(opts = {})
    @cli_helper ||= opts.delete(:cli_helper) || Aptly::CliHelper.new(opts)
    begin
      { snapshot_list: @cli_helper.snapshot_list(opts) }
    rescue Aptly::Error => e
      raise TaskHelper::Error.new(e.message, 'aptly/snapshot-list-error')
    end
  end
end

AptlySnapshotListTask.run if $PROGRAM_NAME == __FILE__
