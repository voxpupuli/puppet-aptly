# frozen_string_literal: true

require 'spec_helper_acceptance'
require 'json'

describe 'aptly bolt tasks' do
  def bolt_task_run(name, options = {})
    optkv = options.map { |k, v| "'#{k}=#{v}'" }
    result = shell("bolt task run -t localhost --format=json '#{name}' #{optkv.join(' ')}")
    JSON.parse(result.stdout.chomp)['items'][0]['value']
  end

  let(:current_arch) { shell('/opt/puppetlabs/bin/facter os.architecture').stdout.chomp }
  let(:keyring) { '/root/keyring_for_tasks.gpg' }

  describe 'apply puppet' do
    specify do
      apply_manifest_on(default, 'include apt; include aptly')
    end
  end

  context 'with mirror' do
    describe 'mirror_create' do
      it 'creates mirror' do
        result = bolt_task_run("aptly::#{subject}",
                               name: 'aptly',
                               url: 'http://repo.aptly.info/',
                               distribution: 'squeeze',
                               component: 'main',
                               filter: 'aptly (>=1.4)',
                               filter_with_deps: true,
                               architectures: current_arch,
                               keyring: keyring)
        expect(result[subject]).to be(true)
      end

      it { expect(command('aptly mirror list -raw').stdout.split(%r{\R})).to include('aptly') }
    end

    describe 'mirror_list' do
      it 'lists mirrors' do
        result = bolt_task_run("aptly::#{subject}")
        aggregate_failures subject do
          expect(result[subject][0]['Name']).to eq('aptly')
          expect(result[subject][0]['ArchiveRoot']).to eq('http://repo.aptly.info/')
        end
      end
    end

    describe 'mirror_show' do
      it 'shows mirrors' do
        result = bolt_task_run("aptly::#{subject}", name: 'aptly')
        aggregate_failures subject do
          expect(result[subject]['Name']).to eq('aptly')
          expect(result[subject]['ArchiveRoot']).to eq('http://repo.aptly.info/')
        end
      end
    end

    describe 'mirror_update' do
      it 'updates mirror' do
        result = bolt_task_run("aptly::#{subject}", name: 'aptly', keyring: keyring)
        expect(result[subject]).to be(true)
      end
    end

    describe 'snapshot_create' do
      it 'creates snapshot' do
        result = bolt_task_run("aptly::#{subject}", name: 'aptly-snapshot-123', from: 'mirror', mirror: 'aptly')
        expect(result[subject]).to be(true)
      end

      it { expect(command('aptly snapshot list -raw').stdout.split(%r{\R})).to include('aptly-snapshot-123') }
    end

    describe 'snapshot_list' do
      it 'lists snapshots' do
        result = bolt_task_run("aptly::#{subject}")
        expect(result[subject][0]['Name']).to eq('aptly-snapshot-123')
      end
    end

    describe 'snapshot_show' do
      it 'shows snapshots' do
        result = bolt_task_run("aptly::#{subject}", name: 'aptly-snapshot-123')
        expect(result[subject]['Name']).to eq('aptly-snapshot-123')
      end
    end

    describe 'publish_snapshot' do
      it 'publishes snapshot' do
        result = bolt_task_run("aptly::#{subject}", name: 'aptly-snapshot-123', prefix: 'aptly', skip_signing: true, skip_bz2: true)
        expect(result[subject]).to be(true)
      end

      it { expect(command('aptly publish list -raw').stdout.split(%r{\R})).to include(%r{aptly\s+squeeze}) }
    end

    describe 'publish_list' do
      it 'lists published objects' do
        result = bolt_task_run("aptly::#{subject}")
        aggregate_failures subject do
          expect(result[subject][0]['Prefix']).to eq('aptly')
          expect(result[subject][0]['Distribution']).to eq('squeeze')
          expect(result[subject][0]['Sources'][0]['Name']).to eq('aptly-snapshot-123')
        end
      end
    end

    describe 'publish_show' do
      it 'shows published objects' do
        result = bolt_task_run("aptly::#{subject}", distribution: 'squeeze', prefix: 'aptly')
        aggregate_failures subject do
          expect(result[subject]['Prefix']).to eq('aptly')
          expect(result[subject]['Distribution']).to eq('squeeze')
          expect(result[subject]['Sources'][0]['Name']).to eq('aptly-snapshot-123')
        end
      end
    end

    describe 'publish_drop' do
      it 'drops published object' do
        result = bolt_task_run("aptly::#{subject}", distribution: 'squeeze', prefix: 'aptly')
        expect(result[subject]).to be(true)
      end

      it { expect(command('aptly publish list -raw').stdout.split(%r{\R})).not_to include(%r{\aaptly\s+squeeze\z}) }
    end

    describe 'snapshot_drop' do
      it 'drops snapshot' do
        result = bolt_task_run("aptly::#{subject}", name: 'aptly-snapshot-123')
        expect(result[subject]).to be(true)
      end

      it { expect(command('aptly snapshot list -raw').stdout.split(%r{\R})).not_to include('aptly-snapshot-123') }
    end

    describe 'mirror_drop' do
      it 'drops mirror' do
        result = bolt_task_run("aptly::#{subject}", name: 'aptly')
        expect(result[subject]).to be(true)
      end

      it { expect(command('aptly mirror list -raw').stdout.split(%r{\R})).not_to include('aptly') }
    end
  end

  context 'with local repo' do
    describe 'repo_create' do
      it 'creates repo' do
        result = bolt_task_run("aptly::#{subject}", name: 'example-repo', comment: 'Example repo', distribution: 'bookworm', architectures: current_arch)
        expect(result[subject]).to be(true)
      end

      it { expect(command('aptly repo list -raw').stdout.split(%r{\R})).to include('example-repo') }
    end

    describe 'repo_list' do
      it 'lists repo' do
        result = bolt_task_run("aptly::#{subject}")
        expect(result[subject][0]['Name']).to eq('example-repo')
      end
    end

    describe 'repo_show' do
      it 'shows repo' do
        result = bolt_task_run("aptly::#{subject}", name: 'example-repo')
        expect(result[subject]['Name']).to eq('example-repo')
      end
    end

    describe 'publish_repo' do
      it 'publishes repo' do
        result = bolt_task_run("aptly::#{subject}", name: 'example-repo', prefix: 'example', skip_signing: true, skip_bz2: true, architectures: current_arch)
        expect(result[subject]).to be(true)
      end

      it { expect(command('aptly publish list -raw').stdout.split(%r{\R})).to include(%r{example\s+bookworm}) }
    end

    describe 'publish_drop' do
      it 'drops published object' do
        result = bolt_task_run("aptly::#{subject}", distribution: 'bookworm', prefix: 'example')
        expect(result[subject]).to be(true)
      end

      it { expect(command('aptly publish list -raw').stdout.split(%r{\R})).not_to include(%r{\aaptly\s+squeeze\z}) }
    end

    describe 'repo_drop' do
      it 'drops repo' do
        result = bolt_task_run("aptly::#{subject}", name: 'example-repo')
        expect(result[subject]).to be(true)
      end

      it { expect(command('aptly repo list -raw').stdout.split(%r{\R})).not_to include('example-repo') }
    end
  end
end
