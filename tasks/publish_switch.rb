#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/cli_helper'
require_relative '../../ruby_task_helper/files/task_helper' unless Object.const_defined?('TaskHelper')

# Switch the mirror
class AptlyPublishSwitchTask < TaskHelper
  def task(opts = {})
    @cli_helper ||= opts.delete(:cli_helper) || Aptly::CliHelper.new(opts)
    @distribution = opts.delete(:distribution)
    @prefix = opts.delete(:prefix)
    @snapshot = opts.delete(:snapshot)
    begin
      { publish_switch: @cli_helper.publish_switch(@distribution, @prefix, @snapshot, opts) }
    rescue Aptly::Error => e
      raise TaskHelper::Error.new(e.message, 'aptly/publish-switch-error')
    end
  end
end

AptlyPublishSwitchTask.run if $PROGRAM_NAME == __FILE__
