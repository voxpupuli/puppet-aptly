#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/cli_helper'
require_relative '../../ruby_task_helper/files/task_helper' unless Object.const_defined?('TaskHelper')

# Update the mirror
class AptlyPublishUpdateTask < TaskHelper
  def task(opts = {})
    @cli_helper ||= opts.delete(:cli_helper) || Aptly::CliHelper.new(opts)
    @distribution = opts.delete(:distribution)
    @prefix = opts.delete(:prefix)
    begin
      { publish_update: @cli_helper.publish_update(@distribution, @prefix, opts) }
    rescue Aptly::Error => e
      raise TaskHelper::Error.new(e.message, 'aptly/publish-update-error')
    end
  end
end

AptlyPublishUpdateTask.run if $PROGRAM_NAME == __FILE__
