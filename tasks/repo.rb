#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/aptly_task_helper'

# Manage a repository
class AptlyRepoTask < AptlyTaskHelper
  def category
    'repo'
  end

  def repo_add(opts = {})
    name = opts.delete(:name)
    package = opts.delete(:package)
    directory = opts.delete(:directory)

    if (package && directory) || !(package || directory)
      raise TaskHelper::Error.new(
        'One of package or directory must be defined',
        'aptly/repo_add-error'
      )
    end

    package_or_directory = package || directory # Select 1st defined value
    PuppetX::Aptly::CliHelper.repo_add(name, package_or_directory, opts)
  end

  def repo_create(opts = {})
    name = opts.delete(:name)
    PuppetX::Aptly::CliHelper.repo_create(name, opts)
  end

  def repo_drop(opts = {})
    name = opts.delete(:name)
    PuppetX::Aptly::CliHelper.repo_drop(name, opts)
  end

  def repo_list(opts = {})
    PuppetX::Aptly::CliHelper.repo_list(opts)
  end

  def repo_remove(opts = {})
    name = opts.delete(:name)
    package_query = opts.delete(:package_query)
    PuppetX::Aptly::CliHelper.repo_remove(name, package_query, opts)
  end
end

AptlyRepoTask.run if $PROGRAM_NAME == __FILE__
