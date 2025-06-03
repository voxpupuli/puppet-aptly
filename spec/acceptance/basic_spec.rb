# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'aptly class' do
  context 'with distro package' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        include apt
        class { 'aptly':
          repo => false,
        }
        PUPPET
      end
    end
    describe command('aptly version') do
      its(:stdout) { is_expected.to match %(aptly version) }
    end

    describe command('aptly mirror list') do
      its(:stdout) { is_expected.to match %(No mirrors found) }
    end

    describe command('aptly repo list') do
      its(:stdout) { is_expected.to match %(No local repositories found) }
    end
  end

  context 'with aptly.info package' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        include apt
        class { 'aptly':
          repo           => true,
          package_ensure => 'latest',
        }
        PUPPET
      end
    end
    describe command('aptly version') do
      its(:stdout) { is_expected.to match %(aptly version) }
    end

    describe command('aptly mirror list') do
      its(:stdout) { is_expected.to match %(No mirrors found) }
    end

    describe command('aptly repo list') do
      its(:stdout) { is_expected.to match %(No local repositories found) }
    end
  end

  context 'mirror' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        include apt
        include aptly
        $package = $facts['os']['name'] ? {
          'Debian' => 'debian-archive-keyring',
          'Ubuntu' => 'ubuntu-keyring',
        }
        package { $package:
          ensure => 'installed',
        }
        exec { 'import_keyring':
          command => "/usr/bin/gpg --no-default-keyring --keyring /usr/share/keyrings/${facts['os']['name'].downcase}-archive-keyring.gpg --export | /usr/bin/gpg --no-default-keyring --keyring trustedkeys.gpg --import",
          creates => '/root/.gnupg/trustedkeys.gpg',
        }
        ~> exec { 'puppetkey':
          command     => '/usr/bin/wget -O - https://apt.puppet.com/keyring.gpg | gpg --no-default-keyring --keyring trustedkeys.gpg --import',
          refreshonly => true,
        }
        -> aptly::mirror { 'puppetlabs':
          location => 'https://apt.puppet.com/',
          key      => 'D6811ED3ADEEB8441AF5AA8F4528B6CD9E61EF26',
          release  => 'bookworm',
          repos    => ['puppet8'],
        }
        PUPPET
      end
    end
    describe command('aptly mirror show puppetlabs') do
      its(:stdout) { is_expected.to match %r{Archive Root URL: https://apt.puppet.com/} }
    end

    # ensures that we have an aptly version with json support,
    # available since 1.5.0
    # https://github.com/aptly-dev/aptly/releases/tag/v1.5.0
    describe command('aptly mirror list -json') do
      its(:stdout) { is_expected.to match %(puppetlabs) }
    end
  end
end
