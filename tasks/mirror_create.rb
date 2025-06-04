#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/puppet_x/voxpupuli/aptly/cli_helper'
require_relative '../../ruby_task_helper/files/task_helper' unless Object.const_defined?('TaskHelper')

# Create the mirror
class AptlyMirrorCreateTask < TaskHelper
  def task(opts = {})
    @cli_helper ||= opts.delete(:cli_helper) || PuppetX::Aptly::CliHelper.new(opts)
    @name = opts.delete(:name)
    @url = opts.delete(:url)
    @distribution = opts.delete(:distribution)
    begin
      { mirror_create: @cli_helper.mirror_create(@name, @url, @distribution, opts) }
    rescue Aptly::Error => e
      raise TaskHelper::Error.new(e.message, 'aptly/mirror-create-error')
    end
  end
end

AptlyMirrorCreateTask.run if $PROGRAM_NAME == __FILE__
