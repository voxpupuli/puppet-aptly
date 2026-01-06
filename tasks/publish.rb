#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/aptly_task_helper'

# Publish something somehow
class AptlyPublishTask < AptlyTaskHelper
  def category
    'publish'
  end

  def publish_drop(opts = {})
    distribution = opts.delete(:distribution)
    prefix = opts.delete(:prefix)
    PuppetX::Aptly::CliHelper.publish_drop(distribution, prefix, opts)
  end

  def publish_show(opts = {})
    distribution = opts.delete(:distribution)
    prefix = opts.delete(:prefix)
    PuppetX::Aptly::CliHelper.publish_show(distribution, prefix, opts)
  end

  def publish_list(opts = {})
    PuppetX::Aptly::CliHelper.publish_list(opts)
  end

  def publish_repo(opts = {})
    name = opts.delete(:name)
    prefix = opts.delete(:prefix)
    PuppetX::Aptly::CliHelper.publish_repo(name, prefix, opts)
  end

  def publish_snapshot(opts = {})
    name = opts.delete(:name)
    prefix = opts.delete(:prefix)
    PuppetX::Aptly::CliHelper.publish_snapshot(name, prefix, opts)
  end

  def publish_switch(opts = {})
    distribution = opts.delete(:distribution)
    prefix = opts.delete(:prefix)
    snapshot = opts.delete(:snapshot)
    PuppetX::Aptly::CliHelper.publish_switch(distribution, prefix, snapshot, opts)
  end

  def publish_update(opts = {})
    distribution = opts.delete(:distribution)
    prefix = opts.delete(:prefix)
    PuppetX::Aptly::CliHelper.publish_update(distribution, prefix, opts)
  end
end

AptlyPublishTask.run if $PROGRAM_NAME == __FILE__
