#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/cli_helper'
require_relative '../../ruby_task_helper/files/task_helper' unless Object.const_defined?('TaskHelper')

# Add package to local repo
class AptlyRepoAddTask < TaskHelper
  def task(opts = {})
    @cli_helper ||= opts.delete(:cli_helper) || Aptly::CliHelper.new(opts)
    @name = opts.delete(:name)
    @package = opts.delete(:package)
    @directory = opts.delete(:directory)

    if (@package && @directory) || !(@package || @directory)
      raise TaskHelper::Error.new(
        'One of package or directory must be defined',
        'aptly/repo-add-error'
      )
    end

    package_or_directory = @package || @directory # Returns 1st defined value

    begin
      { repo_add: @cli_helper.repo_add(@name, package_or_directory, opts) }
    rescue Aptly::Error => e
      raise TaskHelper::Error.new(e.message, 'aptly/repo-add-error')
    end
  end
end

AptlyRepoAddTask.run if $PROGRAM_NAME == __FILE__
