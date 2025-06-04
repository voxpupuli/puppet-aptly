# frozen_string_literal: true

require 'puppet/resource_api/simple_provider'
require_relative '../../../puppet_x/voxpupuli/aptly/cli_helper'

class Puppet::Provider::AptlyMirror::AptlyMirror < Puppet::ResourceApi::SimpleProvider
  def get(context)
    context.debug('Fetching aptly mirrors...')
    mirrors = PuppetX::Aptly::CliHelper.mirror_list
    mirrors.map do |mirror|
      {
        name: mirror['Name'],
        ensure: 'present',
        url: mirror['ArchiveRoot'],
        distribution: mirror['Distribution'],
        component: mirror['Components'],
        architectures: mirror['Architectures'],
        ignore_signatures: mirror['IgnoreSignatures'],
        filter: mirror['Filter'],
        filter_with_deps: mirror['FilterWithDeps'],
        force_components: mirror['SkipComponentCheck'],
        force_architectures: mirror['SkipArchitectureCheck'],
        with_sources: mirror['DownloadSources'],
        with_udebs: mirror['DownloadUdebs'],
        with_installer: mirror['DownloadInstaller'],
      }
    end
  rescue StandardError => e
    context.fail!("Failed to fetch mirrors: #{e.message}")
  end

  def create(context, name, should)
    context.notice("Creating mirror '#{name}'")

    options = {
      architectures: should[:architectures],
      component: should[:component],
      dep_follow_all_variants: should[:dep_follow_all_variants],
      dep_follow_recommends: should[:dep_follow_recommends],
      dep_follow_source: should[:dep_follow_source],
      dep_follow_suggests: should[:dep_follow_suggests],
      distribution: should[:distribution],
      filter: should[:filter],
      filter_with_deps: should[:filter_with_deps],
      force_architectures: should[:force_architectures],
      force_components: should[:force_components],
      ignore_signatures: should[:ignore_signatures],
      keyring: should[:keyring],
      max_tries: should[:max_tries],
      url: should[:url],
      with_installer: should[:with_installer],
      with_sources: should[:with_sources],
      with_udebs: should[:with_udebs],
    }

    PuppetX::Aptly::CliHelper.mirror_create(name, should[:url], should[:distribution], options)
  end

  def update(context, name, should)
    context.notice("Updating mirror '#{name}'")
    # Split properties into those that require recreate and those that can be edited
    recreate_props = %i[
      distribution
      component
      force_architectures
      force_components
      ignore_signatures
    ]

    current = get(context).find { |r| r[:name] == name }
    raise Puppet::Error, "Mirror #{name} not found during update!" if current.nil?

    # Check for changes that requires mirror re-creation
    if recreate_props.any? { |prop| current[prop] != should[prop] }
      context.notice("Recreating mirror '#{name}' due to non-editable changes")
      delete(context, name)
      create(context, name, should)
    else
      # Detect changes only
      changes = should.reject { |k, v| current[k] == v }
      return if changes.empty?

      context.notice("Editing mirror '#{name}' with changes: #{changes}")
      PuppetX::Aptly::CliHelper.mirror_edit(name, changes)
    end
  end

  def delete(context, name)
    context.notice("Deleting mirror '#{name}'")
    PuppetX::Aptly::CliHelper.mirror_drop(name, force: true)
  end
end
