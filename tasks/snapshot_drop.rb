#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/cli_helper'
require_relative '../../ruby_task_helper/files/task_helper' unless Object.const_defined?('TaskHelper')

# Drop the snapshot
class AptlySnapshotDropTask < TaskHelper
  def task(opts = {})
    @cli_helper ||= opts.delete(:cli_helper) || Aptly::CliHelper.new(opts)
    @name = opts.delete(:name)
    begin
      { snapshot_drop: @cli_helper.snapshot_drop(@name, opts) }
    rescue Aptly::Error => e
      raise TaskHelper::Error.new(e.message, 'aptly/snapshot-drop-error')
    end
  end
end

AptlySnapshotDropTask.run if $PROGRAM_NAME == __FILE__
