#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/cli_helper'
require_relative '../../ruby_task_helper/files/task_helper' unless Object.const_defined?('TaskHelper')

# Drop the mirror
class AptlyMirrorDropTask < TaskHelper
  def task(opts = {})
    @cli_helper ||= opts.delete(:cli_helper) || Aptly::CliHelper.new(opts)
    @name = opts.delete(:name)
    begin
      { mirror_drop: @cli_helper.mirror_drop(@name, opts) }
    rescue Aptly::Error => e
      raise TaskHelper::Error.new(e.message, 'aptly/mirror-drop-error')
    end
  end
end

AptlyMirrorDropTask.run if $PROGRAM_NAME == __FILE__
