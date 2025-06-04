#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/puppet_x/voxpupuli/aptly/cli_helper'
require_relative '../../ruby_task_helper/files/task_helper' unless Object.const_defined?('TaskHelper')

# Snapshot the mirror
class AptlyPublishSnapshotTask < TaskHelper
  def task(opts = {})
    @cli_helper ||= opts.delete(:cli_helper) || PuppetX::Aptly::CliHelper.new(opts)
    @name = opts.delete(:name)
    @prefix = opts.delete(:prefix)
    begin
      { publish_snapshot: @cli_helper.publish_snapshot(@name, @prefix, opts) }
    rescue Aptly::Error => e
      raise TaskHelper::Error.new(e.message, 'aptly/publish-snapshot-error')
    end
  end
end

AptlyPublishSnapshotTask.run if $PROGRAM_NAME == __FILE__
