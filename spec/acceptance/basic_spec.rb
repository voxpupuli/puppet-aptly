# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'aptly class' do
  context 'default parameters' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        include apt
        include aptly
        PUPPET
      end
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
  end
end
