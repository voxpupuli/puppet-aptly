#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/aptly_task_helper'

# Manage a snapshot
class AptlySnapshotTask < AptlyTaskHelper
  def category
    'snapshot'
  end

  def snapshot_create(opts = {})
    name = opts.delete(:name)
    from = opts.delete(:from)
    PuppetX::Aptly::CliHelper.snapshot_create(name, from, opts)
  end

  def snapshot_drop(opts = {})
    name = opts.delete(:name)
    PuppetX::Aptly::CliHelper.snapshot_drop(name, opts)
  end

  def snapshot_show(opts = {})
    name = opts.delete(:name)
    PuppetX::Aptly::CliHelper.snapshot_show(name, opts)
  end

  def snapshot_list(opts = {})
    PuppetX::Aptly::CliHelper.snapshot_list(opts)
  end
end

AptlySnapshotTask.run if $PROGRAM_NAME == __FILE__
