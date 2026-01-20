# frozen_string_literal: true

require 'json'
require 'open3'

# Aptly CLI helper
module PuppetX
  module Aptly
    # Define CLI helper error class
    class Error < StandardError
    end

    class CliHelper
      @aptly = 'aptly'

      class << self
        attr_accessor :aptly
      end

      # Mirror
      def self.mirror_create(name, url, distribution, options = {})
        cmd = [@aptly, 'mirror', 'create']
        cmd += parse_common_options(options)
        cmd << "-filter=#{options[:filter]}" if options[:filter]
        cmd << '-filter-with-deps' if options[:filter_with_deps]
        cmd << '-force-architectures' if options[:force_architectures]
        cmd << '-force-components' if options[:force_components]
        cmd << '-ignore-signatures' if options[:ignore_signatures]
        cmd += Array(options[:keyring]).map { |x| "-keyring=#{x}" }
        cmd << "-max-tries=#{options[:max_tries]}" if options[:max_tries]
        cmd << '-with-installer' if options[:with_installer]
        cmd << '-with-sources' if options[:with_sources]
        cmd << '-with-udebs' if options[:with_udebs]
        cmd += [name, url, distribution]
        cmd += Array(options[:component])
        execute(cmd)
      end

      def self.mirror_update(name, options = {})
        cmd = [@aptly, 'mirror', 'update']
        cmd += parse_common_options(options)
        cmd << "-download-limit=#{options[:download_limit]}" if options[:download_limit]
        cmd << "-downloader=#{options[:downloader]}" if options[:downloader]
        cmd << '-force' if options[:force]
        cmd << '-ignore-checksums' if options[:ignore_checksums]
        cmd << '-ignore-signatures' if options[:ignore_signatures]
        cmd += Array(options[:keyring]).map { |x| "-keyring=#{x}" }
        cmd << "-max-tries=#{options[:max_tries]}" if options[:max_tries]
        cmd << '-skip-existing-packages' if options[:skip_existing_packages]
        cmd << name
        execute(cmd)
      end

      def self.mirror_list(options = {})
        something_list('mirror', options)
      end

      def self.mirror_show(name, options = {})
        something_show('mirror', name, options)
      end

      def self.mirror_drop(name, options = {})
        something_drop('mirror', name, options)
      end

      def self.mirror_edit(name, options = {})
        cmd = [@aptly, 'mirror', 'edit']
        cmd += parse_common_options(options)
        cmd << "-archive-url=#{options[:archive_url]}" if options[:archive_url]
        cmd << "-filter=#{options[:filter]}" if options[:filter]
        cmd << '-filter-with-deps' if options[:filter_with_deps]
        cmd << '-ignore-signatures' if options[:ignore_signatures]
        cmd += Array(options[:keyring]).map { |x| "-keyring=#{x}" }
        cmd << '-with-installer' if options[:with_installer]
        cmd << '-with-sources' if options[:with_sources]
        cmd << '-with-udebs' if options[:with_udebs]
        cmd << name

        execute(cmd)
      end

      # Repo
      def self.repo_create(name, options = {})
        cmd = [@aptly, 'repo', 'create']
        cmd += parse_common_options(options)
        cmd << "-comment=#{options[:comment]}" if options[:comment]
        cmd << "-component=#{options[:component]}" if options[:component]
        cmd << "-distribution=#{options[:distribution]}" if options[:distribution]
        cmd << "-uploaders-file=#{options[:uploaders_file]}" if options[:uploaders_file]
        cmd << name

        cmd += ['from', 'snapshot', options[:snapshot]] if options[:snapshot]

        execute(cmd)
      end

      def self.repo_add(name, package_or_directory, options = {})
        cmd = [@aptly, 'repo', 'add']
        cmd += parse_common_options(options)
        cmd << '-force-replace' if options[:force_replace]
        cmd << '-remove-files' if options[:remove_files]
        cmd << name
        cmd << package_or_directory

        execute(cmd)
      end

      def self.repo_remove(name, package_query, options = {})
        cmd = [@aptly, 'repo', 'remove']
        cmd += parse_common_options(options)
        cmd << name
        cmd += Array(package_query)

        execute(cmd)
      end

      def self.repo_list(options = {})
        something_list('repo', options)
      end

      def self.repo_show(name, options = {})
        something_show('repo', name, options)
      end

      def self.repo_drop(name, options = {})
        something_drop('repo', name, options)
      end

      # Snapshot
      def self.snapshot_create(name, from, options = {})
        cmd = [@aptly, 'snapshot', 'create']
        cmd += parse_common_options(options)
        cmd << name

        case from
        when 'mirror'
          raise PuppetX::Aptly::Error, '`mirror` option should be defined' unless options[:mirror]

          cmd += ['from', 'mirror', options[:mirror]]
        when 'repo'
          raise PuppetX::Aptly::Error, '`repo` option should be defined' unless options[:repo]

          cmd += ['from', 'repo', options[:repo]]
        when 'empty'
          cmd += %w[empty]
        else
          raise PuppetX::Aptly::Error, '`from` argument must be one of: mirror, repo, empty'
        end

        execute(cmd)
      end

      def self.snapshot_list(options = {})
        something_list('snapshot', options)
      end

      def self.snapshot_show(name, options = {})
        something_show('snapshot', name, options)
      end

      def self.snapshot_drop(name, options = {})
        something_drop('snapshot', name, options)
      end

      # Publish
      def self.publish_snapshot(names, prefix, options = {})
        publish_something('snapshot', names, prefix, options)
      end

      def self.publish_repo(names, prefix, options = {})
        publish_something('repo', names, prefix, options)
      end

      def self.publish_switch(distribution, prefix, snapshots, options = {})
        publish_somehow('switch', distribution, prefix, snapshots, options)
      end

      def self.publish_update(distribution, prefix, options = {})
        publish_somehow('update', distribution, prefix, nil, options)
      end

      def self.publish_list(options = {})
        something_list('publish', options)
      end

      def self.publish_show(distribution, prefix, options = {})
        cmd = [@aptly, 'publish', 'show', '-json']
        cmd += parse_common_options(options)
        cmd << distribution << prefix
        execute_and_parse(cmd)
      end

      def self.publish_drop(distribution, prefix, options = {})
        cmd = [@aptly, 'publish', 'drop']
        cmd += parse_common_options(options)
        cmd << '-force-drop' if options[:force_drop]
        cmd << '-skip-cleanup' if options[:skip_cleanup]
        cmd << distribution << prefix
        execute(cmd)
      end

      # Private methods

      private_class_method def self.publish_something(what, names, prefix, options)
        cmd = [@aptly, 'publish', what]
        cmd += parse_common_options(options)
        cmd << '-acquire-by-hash' if options[:acquire_by_hash]
        cmd << '-batch' if options[:batch]
        cmd << "-butautomaticupgrades=#{options[:but_automatic_upgrades]}" if options[:but_automatic_upgrades]
        cmd << "-component=#{Array(options[:component]).join(',')}" if options[:component]
        cmd << "-distribution=#{options[:distribution]}" if options[:distribution]
        cmd << '-force-overwrite' if options[:force_overwrite]
        cmd << "-gpg-key=#{options[:gpg_key]}" if options[:gpg_key]
        cmd += Array(options[:keyring]).map { |x| "-keyring=#{x}" }
        cmd << "-label=#{options[:label]}" if options[:label]
        cmd << "-notautomatic=#{options[:not_automatic]}" if options[:not_automatic]
        cmd << "-origin=#{options[:origin]}" if options[:origin]
        cmd << "-passphrase-file=#{options[:passphrase_file]}" if options[:passphrase_file]
        cmd << "-secret-keyring=#{options[:secret_keyring]}" if options[:secret_keyring]
        cmd << '-skip-bz2' if options[:skip_bz2]
        cmd << '-skip-contents' if options[:skip_contents]
        cmd << '-skip-signing' if options[:skip_signing]
        cmd << "-suite=#{options[:suite]}" if options[:suite]

        cmd += Array(names)
        cmd << prefix

        execute(cmd)
      end

      private_class_method def self.publish_somehow(how, distribution, prefix, snapshots, options)
        cmd = [@aptly, 'publish', how]
        cmd += parse_common_options(options)
        cmd << '-batch' if options[:batch]

        cmd << "-component=#{Array(options[:component]).join(',')}" if options[:component] && how == 'switch'

        cmd << '-force-overwrite' if options[:force_overwrite]
        cmd << "-gpg-key=#{options[:gpg_key]}" if options[:gpg_key]
        cmd += Array(options[:keyring]).map { |x| "-keyring=#{x}" }
        cmd << "-passphrase-file=#{options[:passphrase_file]}" if options[:passphrase_file]
        cmd << "-secret-keyring=#{options[:secret_keyring]}" if options[:secret_keyring]
        cmd << '-skip-bz2' if options[:skip_bz2]
        cmd << '-skip-contents' if options[:skip_contents]
        cmd << '-skip-signing' if options[:skip_signing]
        cmd << distribution
        cmd << prefix if prefix

        cmd += Array(snapshots) if how == 'switch'

        execute(cmd)
      end

      private_class_method def self.something_drop(what, name, options)
        cmd = [@aptly, what, 'drop']
        cmd += parse_common_options(options)
        cmd << '-force' if options[:force]
        cmd << name
        execute(cmd)
      end

      private_class_method def self.something_show(what, name, options)
        cmd = [@aptly, what, 'show', '-json']
        cmd += parse_common_options(options)
        cmd << '-with-packages' if options[:with_packages]
        cmd << name
        execute_and_parse(cmd)
      end

      private_class_method def self.something_list(what, options)
        cmd = [@aptly, what, 'list', '-json']
        cmd += parse_common_options(options)
        execute_and_parse(cmd)
      end

      private_class_method def self.parse_common_options(options)
        args = []
        args << "-architectures=#{Array(options[:architectures]).join(',')}" if options[:architectures]
        args << "-config=#{options[:config]}" if options[:config]
        args << '-dep-follow-all-variants' if options[:dep_follow_all_variants]
        args << '-dep-follow-recommends' if options[:dep_follow_recommends]
        args << '-dep-follow-source' if options[:dep_follow_source]
        args << '-dep-follow-suggests' if options[:dep_follow_suggests]
        args
      end

      private_class_method def self.execute_and_parse(cmd)
        out, err, status = Open3.capture3(*cmd)
        return JSON.parse(out) if status.success?

        raise PuppetX::Aptly::Error, "`#{cmd.join(' ')}` failed with status #{status.exitstatus}: #{err}"
      end

      private_class_method def self.execute(cmd)
        _out, err, status = Open3.capture3(*cmd)
        return true if status.success?

        raise PuppetX::Aptly::Error, "`#{cmd.join(' ')}` failed with status #{status.exitstatus}: #{err}"
      end
    end
  end
end
