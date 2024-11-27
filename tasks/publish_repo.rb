#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/cli_helper'
require_relative '../../ruby_task_helper/files/task_helper' unless Object.const_defined?('TaskHelper')

# Repo the mirror
class AptlyPublishRepoTask < TaskHelper
  def task(opts = {})
    @cli_helper ||= opts.delete(:cli_helper) || Aptly::CliHelper.new(opts)
    @name = opts.delete(:name)
    @prefix = opts.delete(:prefix)
    begin
      { publish_repo: @cli_helper.publish_repo(@name, @prefix, opts) }
    rescue Aptly::Error => e
      raise TaskHelper::Error.new(e.message, 'aptly/publish-repo-error')
    end
  end
end

AptlyPublishRepoTask.run if $PROGRAM_NAME == __FILE__
