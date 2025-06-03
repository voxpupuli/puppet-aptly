# Bolt task acceptance test setup

# There are no packages for Debian 12 and Ubuntu 24.04 (noble) yet...
# Install puppet-tools from previous version in this case
case [$facts.get('os.name'), $facts.get('os.distro.release.major')] {
  ['Debian', '12']: {
    apt::source { 'puppet-tools-bullseye':
      location => 'http://apt.puppet.com',
      release  => 'bullseye',
      repos    => 'puppet-tools',
      key      => {
        'source' => 'https://apt.puppet.com/keyring.gpg',
        'name'   => 'puppet.gpg',
      },
      before   => Package['puppet-bolt'],
    }
  }
  ['Ubuntu', '24.04']: {
    apt::source { 'puppet-tools-jammy':
      location => 'http://apt.puppet.com',
      release  => 'jammy',
      repos    => 'puppet-tools',
      key      => {
        'source' => 'https://apt.puppet.com/keyring.gpg',
        'name'   => 'puppet.gpg',
      },
      before   => Package['puppet-bolt'],
    }
  }
  default: {}
}

package { ['puppet-bolt', 'gpg']: ensure => 'installed' }

$puppetlabs_dir = '/root/.puppetlabs'
$aptly_gpg_key = 'EE727D4449467F0E'

$bolt_project = {
  modulepath => '/etc/puppetlabs/code/modules:/etc/puppetlabs/code/environments/production/modules',
  analytics  => false,
}

file {
  [
    '/root/.gnupg',
    $puppetlabs_dir,
    "${puppetlabs_dir}/bolt",
  ]:
    ensure => 'directory',
    ;
  "${puppetlabs_dir}/bolt/bolt-project.yaml":
    ensure  => 'file',
    content => $bolt_project.stdlib::to_yaml,
}

exec { 'import_aptly_gpg_key':
  path    => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => "gpg --no-default-keyring --keyring /root/keyring_for_tasks.gpg --keyserver keyserver.ubuntu.com --recv-keys ${aptly_gpg_key}",
  require => Package['gpg'],
}
