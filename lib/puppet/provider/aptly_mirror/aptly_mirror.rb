# frozen_string_literal: true

require 'puppet/resource_api'
require_relative '../../../puppet_x/voxpupuli/aptly/cli_helper'

class Puppet::Provider::AptlyMirror::AptlyMirror
  def get(context)
    context.debug('Fetching aptly mirrors...')
    mirrors = PuppetX::Aptly::CliHelper.mirror_list
    mirrors.map do |mirror|
      {
        ensure: 'present',
        name: mirror['Name'],
        url: mirror['ArchiveRoot'],
        distribution: mirror['Distribution'],
        architectures: mirror['Architectures'],
        component: mirror['Components'],
        filter: mirror['Filter'],
        filter_with_deps: mirror['FilterWithDeps'],
        force_architectures: mirror['SkipArchitectureCheck'],
        force_components: mirror['SkipComponentCheck'],
        with_installer: mirror['DownloadInstaller'],
        with_sources: mirror['DownloadSources'],
        with_udebs: mirror['DownloadUdebs'],
      }
    end
  rescue StandardError => e
    raise Puppet::Error, "Failed to fetch mirrors: #{e.message}"
  end

  def set(context, changes, noop: false)
    changes.each do |name, change|
      is = change.key?(:is) ? change[:is] : (get(context) || []).find { |r| r[:name] == name }
      context.type.check_schema(is) unless change.key?(:is)
      should = change[:should]

      is = self.class.create_absent(name) if is.nil?
      should = self.class.create_absent(name) if should.nil?

      if is[:ensure].to_s == 'absent' && should[:ensure].to_s == 'present'
        context.creating(name) do
          create(context, name, should, noop: noop)
        end
      elsif is[:ensure].to_s == 'present' && should[:ensure].to_s == 'absent'
        context.deleting(name) do
          delete(context, name, noop: noop)
        end
      elsif is[:ensure].to_s == 'present'
        context.updating(name) do
          update(context, name, should, noop: noop)
        end
      end
    end
  end

  def create(context, name, should, noop: false)
    context.notice("Creating mirror '#{name}'")

    options = {
      architectures: should[:architectures],
      component: should[:component],
      filter: should[:filter],
      filter_with_deps: should[:filter_with_deps],
      force_architectures: should[:force_architectures],
      force_components: should[:force_components],
      with_installer: should[:with_installer],
      with_sources: should[:with_sources],
      with_udebs: should[:with_udebs],
    }

    PuppetX::Aptly::CliHelper.mirror_create(name, should[:url], should[:distribution], options) unless noop
  end

  def update(context, name, should, noop: false)
    context.notice("Updating mirror '#{name}'")
    # Split properties into those that require recreate and those that can be edited
    recreate_props = %i[
      distribution
      component
      force_architectures
      force_components
    ]

    current = get(context).find { |r| r[:name] == name }
    raise Puppet::Error, "Mirror #{name} not found during update!" if current.nil?

    # Check for changes that requires mirror re-creation
    if recreate_props.any? { |prop| current[prop] != should[prop] }
      context.notice("Recreating mirror '#{name}' due to non-editable changes")
      delete(context, name, noop: noop)
      # raise StandardError, should
      create(context, name, should, noop: noop)
    else
      # Detect changes only
      changes = should.reject { |k, v| current[k] == v }
      return if changes.empty?

      context.notice("Editing mirror '#{name}' with changes: #{changes}")
      PuppetX::Aptly::CliHelper.mirror_edit(name, changes) unless noop
    end
  end

  def delete(context, name, noop: false)
    context.notice("Deleting mirror '#{name}'")
    PuppetX::Aptly::CliHelper.mirror_drop(name, force: true) unless noop
  end

  # @api private
  def self.create_absent(name)
    {
      name: name,
      ensure: 'absent',
    }
  end
end
