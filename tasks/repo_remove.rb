#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/cli_helper'
require_relative '../../ruby_task_helper/files/task_helper' unless Object.const_defined?('TaskHelper')

# Remove package to local repo
class AptlyRepoRemoveTask < TaskHelper
  def task(opts = {})
    @cli_helper ||= opts.delete(:cli_helper) || Aptly::CliHelper.new(opts)
    @name = opts.delete(:name)
    @package_query = opts.delete(:package_query)

    begin
      { repo_remove: @cli_helper.repo_remove(@name, @package_query, opts) }
    rescue Aptly::Error => e
      raise TaskHelper::Error.new(e.message, 'aptly/repo-remove-error')
    end
  end
end

AptlyRepoRemoveTask.run if $PROGRAM_NAME == __FILE__
