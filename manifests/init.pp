#
# @summary aptly is a swiss army knife for Debian repository management
#
# @param package_ensure Ensure parameter to pass to the package resource.
# @param config_file Absolute path to the configuration file. Defaults to
# @param config_contents Contents of the config file.
# @param config Hash of configuration options for `/etc/aptly.conf`. See http://www.aptly.info/#configuration
# @param repo Whether to configure an apt::source for `repo.aptly.info`. You might want to disable this when you've mirrored that yourself.
# @param key_server Key server to use when `$repo` is true.
# @param user The user to use when performing an aptly command
# @param config_group The the group ownership of the configuration file. Defaults to $user name.
# @param aptly_repos Hash of aptly repos which is passed to aptly::repo
# @param aptly_mirrors Hash of aptly mirrors which is passed to aptly::mirror
#
class aptly (
  String $package_ensure            = 'installed',
  Stdlib::Absolutepath $config_file = '/etc/aptly.conf',
  Hash $config                      = {},
  Optional[String] $config_contents = undef,
  Boolean $repo                     = true,
  Stdlib::Fqdn $key_server          = 'keyserver.ubuntu.com',
  String $user                      = 'root',
  String[1] $config_group           = $user,
  Hash $aptly_repos                 = {},
  Hash $aptly_mirrors               = {},
) {
  if $repo {
    apt::source { 'aptly':
      location => 'http://repo.aptly.info/release',
      repos    => 'main',
      key      => {
        name   => 'aptly.asc',
        source => 'https://www.aptly.info/pubkey.txt',
      },
    }

    Apt::Source['aptly'] -> Class['apt::update'] -> Package['aptly']
  }

  package { 'aptly':
    ensure => $package_ensure,
  }

  $config_file_contents = $config_contents ? {
    undef   => $config.stdlib::to_json_pretty,
    default => $config_contents,
  }

  file { $config_file:
    ensure    => file,
    content   => $config_file_contents,
    owner     => $user,
    group     => $config_group,
    mode      => '0440',
    show_diff => false,
  }

  $aptly_cmd = "/usr/bin/aptly -config ${config_file}"

  # Hiera support
  $aptly_repos.each| String[1] $key, Hash $values| {
    aptly::repo { $key:
      * => $values,
    }
  }
  $aptly_mirrors.each| String[1] $key, Hash $values| {
    aptly::mirror { $key:
      * => $values,
    }
  }
}
