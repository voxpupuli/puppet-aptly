# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/puppet_x/voxpupuli/aptly/cli_helper'

describe PuppetX::Aptly::CliHelper do
  let(:capture3_success) do
    rc = instance_double(Process::Status)
    allow(rc).to receive(:success?).and_return(true)
    allow(rc).to receive(:exitstatus).and_return(0)
    rc
  end
  let(:capture3_failure) do
    rc = instance_double(Process::Status)
    allow(rc).to receive(:success?).and_return(false)
    allow(rc).to receive(:exitstatus).and_return(123)
    rc
  end
  let(:capture3_result) { capture3_success }
  let(:capture3_out) { '' }
  let(:capture3_err) { '' }
  let(:init_args) { {} }
  let(:cli_helper) { described_class.new(init_args) }

  before do
    allow(Open3).to receive(:capture3).with(*cmd).and_return([capture3_out, capture3_err, capture3_result])
  end

  describe '#mirror_create' do
    context 'with just required parameters' do
      let(:args) do
        [
          'bookworm-main',
          'http://deb.debian.org/debian/',
          'bookworm',
        ]
      end
      let(:cmd) do
        %w[aptly mirror create bookworm-main http://deb.debian.org/debian/ bookworm]
      end

      specify do
        cli_helper.mirror_create(*args)
        expect(Open3).to have_received(:capture3).with(*cmd).once
      end
    end

    context 'with custom parameters' do
      let(:args) do
        [
          'bookworm-main',
          'http://deb.debian.org/debian/',
          'bookworm',
          {
            component: %w[main updates],
            architectures: %w[amd64 arm64],
            config: '/home/test/aptly.conf',
            dep_follow_all_variants: true,
            dep_follow_recommends: true,
            dep_follow_source: true,
            dep_follow_suggests: true,
            filter: 'foo',
            filter_with_deps: true,
            ignore_signatures: true,
            keyring: '/home/aptly/keyring.gpg',
            max_tries: 5,
            with_installer: true,
            with_sources: true,
            with_udebs: true,
          }
        ]
      end
      let(:cmd) do
        %w[
          aptly mirror create -architectures=amd64,arm64
          -config=/home/test/aptly.conf -dep-follow-all-variants
          -dep-follow-recommends -dep-follow-source -dep-follow-suggests
          -filter=foo -filter-with-deps -ignore-signatures
          -keyring=/home/aptly/keyring.gpg -max-tries=5 -with-installer
          -with-sources -with-udebs bookworm-main http://deb.debian.org/debian/
          bookworm main updates
        ]
      end

      specify do
        cli_helper.mirror_create(*args)
        expect(Open3).to have_received(:capture3).with(*cmd).once
      end
    end
  end

  describe '#mirror_update' do
    let(:args) do
      [
        'bookworm-main',
        {
          architectures: %w[amd64 arm64],
          dep_follow_all_variants: true,
          dep_follow_recommends: true,
          dep_follow_source: true,
          dep_follow_suggests: true,
          download_limit: 100,
          downloader: 'default',
          force: true,
          ignore_checksums: true,
          ignore_signatures: true,
          keyring: ['/home/aptly/example_keyring1.gpg', '/home/aptly/example_keyring2.gpg'],
          max_tries: 5,
          skip_existing_packages: true,
        }
      ]
    end
    let(:cmd) do
      %w[
        aptly mirror update -architectures=amd64,arm64 -dep-follow-all-variants
        -dep-follow-recommends -dep-follow-source -dep-follow-suggests
        -download-limit=100 -downloader=default -force -ignore-checksums
        -ignore-signatures -keyring=/home/aptly/example_keyring1.gpg
        -keyring=/home/aptly/example_keyring2.gpg -max-tries=5
        -skip-existing-packages bookworm-main
      ]
    end

    specify do
      cli_helper.mirror_update(*args)
      expect(Open3).to have_received(:capture3).with(*cmd).once
    end
  end

  describe '#mirror_list' do
    let(:expected_result) { [{ 'Name' => 'bookworm-main' }] }
    let(:capture3_out) { expected_result.to_json }
    let(:cmd) { %w[aptly mirror list -json] }

    specify do
      out = cli_helper.mirror_list
      expect(Open3).to have_received(:capture3).with(*cmd).once
      expect(out).to eq(expected_result)
    end
  end

  describe '#mirror_drop' do
    let(:cmd) { %w[aptly mirror drop -force bookworm-main] }

    specify do
      cli_helper.mirror_drop('bookworm-main', force: true)
      expect(Open3).to have_received(:capture3).with(*cmd).once
    end
  end

  describe '#mirror_edit' do
    let(:args) do
      [
        'bookworm-main',
        {
          architectures: %w[amd64 arm64],
          dep_follow_all_variants: true,
          dep_follow_recommends: true,
          dep_follow_source: true,
          dep_follow_suggests: true,
          archive_url: 'http://deb.debian.org/debian/',
          filter: 'foo',
          filter_with_deps: true,
          ignore_signatures: true,
          keyring: ['/home/aptly/example_keyring1.gpg', '/home/aptly/example_keyring2.gpg'],
          with_installer: true,
          with_sources: true,
          with_udebs: true,
        }
      ]
    end
    let(:cmd) do
      %w[
        aptly mirror edit -architectures=amd64,arm64 -dep-follow-all-variants
        -dep-follow-recommends -dep-follow-source -dep-follow-suggests
        -archive-url=http://deb.debian.org/debian/
        -filter=foo -filter-with-deps -ignore-signatures
        -keyring=/home/aptly/example_keyring1.gpg
        -keyring=/home/aptly/example_keyring2.gpg
        -with-installer -with-sources -with-udebs
        bookworm-main
      ]
    end

    specify do
      cli_helper.mirror_edit(*args)
      expect(Open3).to have_received(:capture3).with(*cmd).once
    end
  end

  describe '#repo_create' do
    let(:opts) do
      {
        architectures: %w[amd64 arm64],
        dep_follow_all_variants: true,
        dep_follow_recommends: true,
        dep_follow_source: true,
        dep_follow_suggests: true,
        comment: 'Example Repository',
        component: 'main',
        distribution: 'bookworm',
        uploaders_file: '/home/aptly/uploaders.json',
      }
    end
    let(:name) { 'example-repo' }
    let(:cmd) do
      (%w[
        aptly repo create -architectures=amd64,arm64 -dep-follow-all-variants
        -dep-follow-recommends -dep-follow-source -dep-follow-suggests
      ] + ['-comment=Example Repository'] + %w[
        -component=main -distribution=bookworm
        -uploaders-file=/home/aptly/uploaders.json
      ]) + [name]
    end

    specify do
      cli_helper.repo_create(name, opts)
      expect(Open3).to have_received(:capture3).with(*cmd).once
    end

    context 'from snapshot' do
      let(:cmd) { super() + %w[from snapshot example-snapshot-123] }

      specify do
        cli_helper.repo_create(name, opts.merge(snapshot: 'example-snapshot-123'))
        expect(Open3).to have_received(:capture3).with(*cmd).once
      end
    end
  end

  describe '#repo_add' do
    let(:cmd) { %w[aptly repo add -force-replace -remove-files example-repo foo] }

    specify do
      cli_helper.repo_add('example-repo', 'foo', force_replace: true, remove_files: true)
      expect(Open3).to have_received(:capture3).with(*cmd).once
    end
  end

  describe '#repo_remove' do
    let(:cmd) { %w[aptly repo remove example-repo foo] }

    specify do
      cli_helper.repo_remove('example-repo', 'foo')
      expect(Open3).to have_received(:capture3).with(*cmd).once
    end
  end

  describe '#repo_list' do
    let(:expected_result) { [{ 'Name' => 'example-repo' }] }
    let(:capture3_out) { expected_result.to_json }
    let(:cmd) { %w[aptly repo list -json] }

    specify do
      out = cli_helper.repo_list
      expect(Open3).to have_received(:capture3).with(*cmd).once
      expect(out).to eq(expected_result)
    end
  end

  describe '#repo_drop' do
    let(:cmd) { %w[aptly repo drop -force example-repo] }

    specify do
      cli_helper.repo_drop('example-repo', force: true)
      expect(Open3).to have_received(:capture3).with(*cmd).once
    end
  end

  describe '#snapshot_create' do
    let(:opts) do
      {
        architectures: %w[amd64 arm64],
        dep_follow_all_variants: true,
        dep_follow_recommends: true,
        dep_follow_source: true,
        dep_follow_suggests: true,
      }
    end
    let(:name) { 'example-snapshot-123' }
    let(:cmd) do
      %w[
        aptly snapshot create -architectures=amd64,arm64 -dep-follow-all-variants
        -dep-follow-recommends -dep-follow-source -dep-follow-suggests
      ] + [name]
    end

    context 'from mirror' do
      let(:cmd) { super() + %w[from mirror bookworm-main] }

      specify do
        cli_helper.snapshot_create(name, 'mirror', opts.merge(mirror: 'bookworm-main'))
        expect(Open3).to have_received(:capture3).with(*cmd).once
      end
    end

    context 'from repo' do
      let(:cmd) { super() + %w[from repo example-repo] }

      specify do
        cli_helper.snapshot_create(name, 'repo', opts.merge(from: 'repo', repo: 'example-repo'))
        expect(Open3).to have_received(:capture3).with(*cmd).once
      end
    end

    context 'empty' do
      let(:cmd) { super() + %w[empty] }

      specify do
        cli_helper.snapshot_create(name, 'empty', opts.merge(from: 'empty'))
        expect(Open3).to have_received(:capture3).with(*cmd).once
      end
    end
  end

  describe '#snapshot_list' do
    let(:expected_result) { [{ 'Name' => 'example-snapshot-123' }] }
    let(:capture3_out) { expected_result.to_json }
    let(:cmd) { %w[aptly snapshot list -json] }

    specify do
      out = cli_helper.snapshot_list
      expect(Open3).to have_received(:capture3).with(*cmd).once
      expect(out).to eq(expected_result)
    end
  end

  describe '#snapshot_drop' do
    let(:cmd) { %w[aptly snapshot drop -force example-snapshot-123] }

    specify do
      cli_helper.snapshot_drop('example-snapshot-123', force: true)
      expect(Open3).to have_received(:capture3).with(*cmd).once
    end
  end

  describe '#publish_snapshot' do
    let(:args) do
      [
        %w[
          bookworm-security-main-123
          bookworm-security-contrib-123
          bookworm-security-non-free-123
          bookworm-security-non-free-firmware-123
        ],
        'current/debian-security',
        {
          architectures: %w[amd64 arm64],
          dep_follow_all_variants: true,
          dep_follow_recommends: true,
          dep_follow_source: true,
          dep_follow_suggests: true,
          acquire_by_hash: true,
          batch: true,
          but_automatic_upgrades: 'no',
          component: %w[main contrib non-free non-free-firmware],
          distribution: 'bookworm',
          force_overwrite: true,
          gpg_key: 'ABCDEFGH',
          keyring: '/home/aptly/keyring.gpg',
          label: 'Debian-Security',
          not_automatic: 'no',
          origin: 'Debian',
          passphrase_file: '/home/aptly/passphrase.txt',
          secret_keyring: '/home/aptly/secret-keyring.gpg',
          skip_bz2: true,
          skip_contents: true,
          skip_signing: true,
          suite: 'stable-security',
        }
      ]
    end
    let(:cmd) do
      %w[
        aptly publish snapshot -architectures=amd64,arm64
        -dep-follow-all-variants -dep-follow-recommends -dep-follow-source
        -dep-follow-suggests -acquire-by-hash -batch -butautomaticupgrades=no
        -component=main,contrib,non-free,non-free-firmware
        -distribution=bookworm -force-overwrite -gpg-key=ABCDEFGH
        -keyring=/home/aptly/keyring.gpg -label=Debian-Security
        -notautomatic=no -origin=Debian
        -passphrase-file=/home/aptly/passphrase.txt
        -secret-keyring=/home/aptly/secret-keyring.gpg -skip-bz2 -skip-contents
        -skip-signing -suite=stable-security bookworm-security-main-123
        bookworm-security-contrib-123 bookworm-security-non-free-123
        bookworm-security-non-free-firmware-123 current/debian-security
      ]
    end

    specify do
      cli_helper.publish_snapshot(*args)
      expect(Open3).to have_received(:capture3).with(*cmd).once
    end
  end

  describe '#publish_repo' do
    let(:args) do
      [
        'example-repo',
        'current/example-repo',
        {
          architectures: 'amd64',
          dep_follow_all_variants: true,
          dep_follow_recommends: true,
          dep_follow_source: true,
          dep_follow_suggests: true,
          acquire_by_hash: true,
          batch: true,
          but_automatic_upgrades: 'no',
          component: 'main',
          distribution: 'bookworm',
          force_overwrite: true,
          gpg_key: 'ABCDEFGH',
          keyring: '/home/aptly/keyring.gpg',
          label: 'Example-Repo',
          not_automatic: 'no',
          origin: 'example.com',
          passphrase_file: '/home/aptly/passphrase.txt',
          secret_keyring: '/home/aptly/secret-keyring.gpg',
          skip_bz2: true,
          skip_contents: true,
          skip_signing: true,
          suite: 'bookworm',
        }
      ]
    end
    let(:cmd) do
      %w[
        aptly publish repo -architectures=amd64 -dep-follow-all-variants
        -dep-follow-recommends -dep-follow-source -dep-follow-suggests
        -acquire-by-hash -batch -butautomaticupgrades=no -component=main
        -distribution=bookworm -force-overwrite -gpg-key=ABCDEFGH
        -keyring=/home/aptly/keyring.gpg -label=Example-Repo -notautomatic=no
        -origin=example.com -passphrase-file=/home/aptly/passphrase.txt
        -secret-keyring=/home/aptly/secret-keyring.gpg -skip-bz2 -skip-contents
        -skip-signing -suite=bookworm example-repo current/example-repo
      ]
    end

    specify do
      cli_helper.publish_repo(*args)
      expect(Open3).to have_received(:capture3).with(*cmd).once
    end
  end

  describe '#publish_switch' do
    let(:args) do
      [
        'bookworm',
        'current/debian-security',
        %w[
          bookworm-security-main-123
          bookworm-security-contrib-123
          bookworm-security-non-free-123
          bookworm-security-non-free-firmware-123
        ],
        {
          architectures: %w[amd64 arm64],
          dep_follow_all_variants: true,
          dep_follow_recommends: true,
          dep_follow_source: true,
          dep_follow_suggests: true,
          acquire_by_hash: true,
          batch: true,
          component: %w[main contrib non-free non-free-firmware],
          force_overwrite: true,
          gpg_key: 'ABCDEFGH',
          keyring: '/home/aptly/keyring.gpg',
          passphrase_file: '/home/aptly/passphrase.txt',
          secret_keyring: '/home/aptly/secret-keyring.gpg',
          skip_bz2: true,
          skip_contents: true,
          skip_signing: true,
        }
      ]
    end
    let(:cmd) do
      %w[
        aptly publish switch -architectures=amd64,arm64
        -dep-follow-all-variants -dep-follow-recommends -dep-follow-source
        -dep-follow-suggests -batch
        -component=main,contrib,non-free,non-free-firmware -force-overwrite
        -gpg-key=ABCDEFGH -keyring=/home/aptly/keyring.gpg
        -passphrase-file=/home/aptly/passphrase.txt
        -secret-keyring=/home/aptly/secret-keyring.gpg -skip-bz2 -skip-contents
        -skip-signing bookworm current/debian-security
        bookworm-security-main-123 bookworm-security-contrib-123
        bookworm-security-non-free-123 bookworm-security-non-free-firmware-123
      ]
    end

    specify do
      cli_helper.publish_switch(*args)
      expect(Open3).to have_received(:capture3).with(*cmd).once
    end
  end

  describe '#publish_update' do
    let(:args) do
      [
        'bookworm',
        'current/example-repo',
        {
          architectures: 'amd64',
          dep_follow_all_variants: true,
          dep_follow_recommends: true,
          dep_follow_source: true,
          dep_follow_suggests: true,
          acquire_by_hash: true,
          batch: true,
          component: 'main',
          force_overwrite: true,
          gpg_key: 'ABCDEFGH',
          keyring: '/home/aptly/keyring.gpg',
          passphrase_file: '/home/aptly/passphrase.txt',
          secret_keyring: '/home/aptly/secret-keyring.gpg',
          skip_bz2: true,
          skip_contents: true,
          skip_signing: true,
        }
      ]
    end
    let(:cmd) do
      %w[
        aptly publish update -architectures=amd64
        -dep-follow-all-variants -dep-follow-recommends -dep-follow-source
        -dep-follow-suggests -batch -force-overwrite -gpg-key=ABCDEFGH
        -keyring=/home/aptly/keyring.gpg
        -passphrase-file=/home/aptly/passphrase.txt
        -secret-keyring=/home/aptly/secret-keyring.gpg -skip-bz2 -skip-contents
        -skip-signing bookworm current/example-repo
      ]
    end

    specify do
      cli_helper.publish_update(*args)
      expect(Open3).to have_received(:capture3).with(*cmd).once
    end
  end

  describe '#publish_list' do
    let(:expected_result) { [{ 'Distribution' => 'bookworm', 'Prefix' => 'current/debian' }] }
    let(:capture3_out) { expected_result.to_json }
    let(:cmd) { %w[aptly publish list -json] }

    specify do
      out = cli_helper.publish_list
      expect(Open3).to have_received(:capture3).with(*cmd).once
      expect(out).to eq(expected_result)
    end
  end

  describe '#publish_drop' do
    let(:cmd) { %w[aptly publish drop -force-drop -skip-cleanup bookworm current/debian] }

    specify do
      cli_helper.publish_drop('bookworm', 'current/debian', force_drop: true, skip_cleanup: true)
      expect(Open3).to have_received(:capture3).with(*cmd).once
    end
  end
end
