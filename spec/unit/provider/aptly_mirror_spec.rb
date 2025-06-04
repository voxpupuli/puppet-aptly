# frozen_string_literal: true

require 'json'
require 'spec_helper'
require 'puppet/resource_api/base_context'

module Puppet::Provider::AptlyMirror; end
require 'puppet/provider/aptly_mirror/aptly_mirror'

describe Puppet::Provider::AptlyMirror::AptlyMirror do
  subject(:provider) { described_class.new }

  let(:cli_helper) { class_double(PuppetX::Aptly::CliHelper) } # see stub_const below also
  let(:context) do
    c = instance_double(Puppet::ResourceApi::BaseContext, 'context')
    allow(c).to receive(:debug)
    # allow(c).to receive(:notice)
    c
  end
  let(:mirror_list) do
    [
      {
        'UUID' => '6f4f67ff-428a-45eb-8f5d-e1ea9f613015',
        'Name' => 'bookworm-main',
        'ArchiveRoot' => 'http://deb.debian.org/debian/',
        'Distribution' => 'bookworm',
        'Components' => [
          'main'
        ],
        'Architectures' => [
          'amd64'
        ],
        'Meta' => {},
        'LastDownloadDate' => '2025-06-05T08:37:02.335253951Z',
        'Filter' => '',
        'Status' => 0,
        'FilterWithDeps' => false,
        'SkipComponentCheck' => false,
        'SkipArchitectureCheck' => false,
        'DownloadSources' => true,
        'DownloadUdebs' => true,
        'DownloadInstaller' => true,
      },
      {
        'UUID' => 'fb07a6e8-402c-463e-8644-915418c1bdae',
        'Name' => 'bullseye-main',
        'ArchiveRoot' => 'http://deb.debian.org/debian/',
        'Distribution' => 'bullseye',
        'Components' => [
          'main'
        ],
        'Architectures' => [
          'amd64'
        ],
        'Meta' => {},
        'LastDownloadDate' => '2025-06-05T00:01:52.147344977Z',
        'Filter' => '',
        'Status' => 0,
        'FilterWithDeps' => false,
        'SkipComponentCheck' => false,
        'SkipArchitectureCheck' => false,
        'DownloadSources' => false,
        'DownloadUdebs' => false,
        'DownloadInstaller' => false,
      },
    ]
  end

  before do
    # Replace the class with double
    stub_const('PuppetX::Aptly::CliHelper', cli_helper)
  end

  describe '#get' do
    it 'processes resources' do
      allow(cli_helper).to receive(:mirror_list).with(no_args).and_return(mirror_list)

      expect(provider.get(context)).to eq [
        {
          architectures: ['amd64'],
          component: ['main'],
          distribution: 'bookworm',
          ensure: 'present',
          filter: '',
          filter_with_deps: false,
          force_architectures: false,
          force_components: false,
          ignore_signatures: nil,
          name: 'bookworm-main',
          url: 'http://deb.debian.org/debian/',
          with_installer: true,
          with_sources: true,
          with_udebs: true,
        },
        {
          architectures: ['amd64'],
          component: ['main'],
          distribution: 'bullseye',
          ensure: 'present',
          filter: '',
          filter_with_deps: false,
          force_architectures: false,
          force_components: false,
          ignore_signatures: nil,
          name: 'bullseye-main',
          url: 'http://deb.debian.org/debian/',
          with_installer: false,
          with_sources: false,
          with_udebs: false,
        },
      ]
    end
  end

  describe '#create' do
    let(:name) { 'openvox-mirror' }
    let(:wanted) do
      {
        architectures: ['amd64'],
        component: %w[openvox7 openvox8],
        distribution: 'debian12',
        dep_follow_all_variants: false,
        dep_follow_recommends: false,
        dep_follow_source: false,
        dep_follow_suggests: false,
        filter: nil,
        filter_with_deps: false,
        force_architectures: false,
        force_components: false,
        ignore_signatures: false,
        keyring: ['/root/keyring.gpg'],
        max_tries: 100,
        url: 'https://apt.voxpupuli.org',
        with_installer: false,
        with_sources: false,
        with_udebs: false,
      }
    end

    it 'creates the resource' do
      allow(context).to receive(:notice)
      allow(cli_helper).to receive(:mirror_create).with(name, 'https://apt.voxpupuli.org', 'debian12', wanted).and_return(true)

      provider.create(context, name, wanted)
      expect(cli_helper).to have_received(:mirror_create).once
    end
  end

  describe '#update' do
    context 'when can be updated' do
      let(:name) { 'bookworm-main' }
      let(:wanted) do
        {
          architectures: ['amd64'],
          component: ['main'],
          distribution: 'bookworm',
          filter: '',
          filter_with_deps: false,
          force_architectures: false,
          force_components: false,
          ignore_signatures: nil,
          name: 'bookworm-main',
          url: 'http://deb.debian.org/debian/',
          with_installer: true,
          with_sources: false,
          with_udebs: true,
        }
      end

      it 'edits the resource' do
        allow(context).to receive(:notice).with("Updating mirror '#{name}'")
        allow(context).to receive(:notice).with("Editing mirror '#{name}' with changes: {:with_sources=>false}")
        # get()
        allow(cli_helper).to receive(:mirror_list).with(no_args).and_return(mirror_list)
        allow(cli_helper).to receive(:mirror_edit).with(name, { with_sources: false }).and_return(true)

        provider.update(context, name, wanted)
        expect(cli_helper).to have_received(:mirror_edit).once
      end
    end

    context 'when needs to be re-created' do
      let(:name) { 'bookworm-main' }
      let(:wanted) do
        {
          architectures: ['amd64'],
          component: %w[main contrib],
          distribution: 'bookworm',
          filter: '',
          filter_with_deps: false,
          force_architectures: false,
          force_components: false,
          ignore_signatures: nil,
          # name: 'bookworm-main',
          url: 'http://deb.debian.org/debian/',
          with_installer: true,
          with_sources: false,
          with_udebs: true,
          # what to do with those attributes?
          dep_follow_all_variants: false,
          dep_follow_recommends: false,
          dep_follow_source: false,
          dep_follow_suggests: false,
          keyring: nil,
          max_tries: nil,
        }
      end

      it 'edits the resource' do
        allow(context).to receive(:notice)
        # get()
        allow(cli_helper).to receive(:mirror_list).with(no_args).and_return(mirror_list)
        # delete()
        allow(cli_helper).to receive(:mirror_drop).with(name, force: true).and_return(true)
        # create()
        allow(cli_helper).to receive(:mirror_create).with(name, 'http://deb.debian.org/debian/', 'bookworm', wanted).and_return(true)

        provider.update(context, name, wanted)
        expect(cli_helper).to have_received(:mirror_drop).once
        expect(cli_helper).to have_received(:mirror_create).once
      end
    end
  end

  describe '#delete' do
    let(:name) { 'openvox-mirror' }

    it 'processes resources' do
      allow(context).to receive(:notice)
      allow(cli_helper).to receive(:mirror_drop).with(name, force: true).and_return(true)

      provider.delete(context, name)
    end
  end
end
