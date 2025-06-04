#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/puppet_x/voxpupuli/aptly/cli_helper'
require_relative '../../ruby_task_helper/files/task_helper' unless Object.const_defined?('TaskHelper')

# Drop the repo
class AptlyRepoDropTask < TaskHelper
  def task(opts = {})
    @cli_helper ||= opts.delete(:cli_helper) || PuppetX::Aptly::CliHelper.new(opts)
    @name = opts.delete(:name)
    begin
      { repo_drop: @cli_helper.repo_drop(@name, opts) }
    rescue Aptly::Error => e
      raise TaskHelper::Error.new(e.message, 'aptly/repo-drop-error')
    end
  end
end

AptlyRepoDropTask.run if $PROGRAM_NAME == __FILE__
