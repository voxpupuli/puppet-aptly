#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/puppet_x/voxpupuli/aptly/cli_helper'
require_relative '../../ruby_task_helper/files/task_helper' unless Object.const_defined?('TaskHelper')

# Update the mirror
class AptlyMirrorUpdateTask < TaskHelper
  def task(opts = {})
    @cli_helper ||= opts.delete(:cli_helper) || PuppetX::Aptly::CliHelper.new(opts)
    @name = opts.delete(:name)
    begin
      { mirror_update: @cli_helper.mirror_update(@name, opts) }
    rescue Aptly::Error => e
      raise TaskHelper::Error.new(e.message, 'aptly/mirror-update-error')
    end
  end
end

AptlyMirrorUpdateTask.run if $PROGRAM_NAME == __FILE__
