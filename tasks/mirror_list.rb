#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/puppet_x/voxpupuli/aptly/cli_helper'
require_relative '../../ruby_task_helper/files/task_helper' unless Object.const_defined?('TaskHelper')

# List mirrors
class AptlyMirrorListTask < TaskHelper
  def task(opts = {})
    @cli_helper ||= opts.delete(:cli_helper) || PuppetX::Aptly::CliHelper.new(opts)
    begin
      { mirror_list: @cli_helper.mirror_list(opts) }
    rescue Aptly::Error => e
      raise TaskHelper::Error.new(e.message, 'aptly/mirror-list-error')
    end
  end
end

AptlyMirrorListTask.run if $PROGRAM_NAME == __FILE__
