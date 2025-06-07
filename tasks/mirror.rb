#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/aptly_task_helper'

# Manage a mirror
class AptlyMirrorTask < AptlyTaskHelper
  def category
    'mirror'
  end

  def mirror_create(opts = {})
    name = opts.delete(:name)
    url = opts.delete(:url)
    distribution = opts.delete(:distribution)
    PuppetX::Aptly::CliHelper.mirror_create(name, url, distribution, opts)
  end

  def mirror_drop(opts = {})
    name = opts.delete(:name)
    PuppetX::Aptly::CliHelper.mirror_drop(name, opts)
  end

  def mirror_list(opts = {})
    PuppetX::Aptly::CliHelper.mirror_list(opts)
  end

  def mirror_update(opts = {})
    name = opts.delete(:name)
    PuppetX::Aptly::CliHelper.mirror_update(name, opts)
  end
end

AptlyMirrorTask.run if $PROGRAM_NAME == __FILE__
