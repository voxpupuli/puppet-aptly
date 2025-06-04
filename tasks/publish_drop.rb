#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/puppet_x/voxpupuli/aptly/cli_helper'
require_relative '../../ruby_task_helper/files/task_helper' unless Object.const_defined?('TaskHelper')

# Drop publishs
class AptlyPublishDropTask < TaskHelper
  def task(opts = {})
    @cli_helper ||= opts.delete(:cli_helper) || PuppetX::Aptly::CliHelper.new(opts)
    @distribution = opts.delete(:distribution)
    @prefix = opts.delete(:prefix)
    begin
      { publish_drop: @cli_helper.publish_drop(@distribution, @prefix, opts) }
    rescue Aptly::Error => e
      raise TaskHelper::Error.new(e.message, 'aptly/publish-drop-error')
    end
  end
end

AptlyPublishDropTask.run if $PROGRAM_NAME == __FILE__
