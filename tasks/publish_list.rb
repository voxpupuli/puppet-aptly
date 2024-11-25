#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/cli_helper'
require_relative '../../ruby_task_helper/files/task_helper' unless Object.const_defined?('TaskHelper')

# List publishs
class AptlyPublishListTask < TaskHelper
  def task(opts = {})
    @cli_helper ||= opts.delete(:cli_helper) || Aptly::CliHelper.new(opts)
    begin
      { publish_list: @cli_helper.publish_list(opts) }
    rescue Aptly::Error => e
      raise TaskHelper::Error.new(e.message, 'aptly/publish-list-error')
    end
  end
end

AptlyPublishListTask.run if $PROGRAM_NAME == __FILE__
