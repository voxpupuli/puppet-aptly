#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/cli_helper'
require_relative '../../ruby_task_helper/files/task_helper' unless Object.const_defined?('TaskHelper')

# Create the snapshot
class AptlySnapshotCreateTask < TaskHelper
  def task(opts = {})
    @cli_helper ||= opts.delete(:cli_helper) || Aptly::CliHelper.new(opts)
    @name = opts.delete(:name)
    @from = opts.delete(:from)
    begin
      { snapshot_create: @cli_helper.snapshot_create(@name, @from, opts) }
    rescue Aptly::Error => e
      raise TaskHelper::Error.new(e.message, 'aptly/snapshot-create-error')
    end
  end
end

AptlySnapshotCreateTask.run if $PROGRAM_NAME == __FILE__
