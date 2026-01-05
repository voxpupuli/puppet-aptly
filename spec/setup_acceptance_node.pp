# Bolt task acceptance test setup

# We use aptly APT repository in acceptance tests
# Below is their GPG key ID
$aptly_gpg_key = 'EE727D4449467F0E'

# Install packages required
package { ['openbolt', 'gpg']: ensure => 'installed' }

$puppetlabs_dir = '/root/.puppetlabs'
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

# Pre-import aptly APT repository GPG key to use in tests
exec { 'import_aptly_gpg_key':
  path    => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => "gpg --no-default-keyring --keyring /root/keyring_for_tasks.gpg --keyserver keyserver.ubuntu.com --recv-keys ${aptly_gpg_key}",
  require => Package['gpg'],
}
