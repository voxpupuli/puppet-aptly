#
# @summary Install and configure Aptly's API Service
#
# @param ensure Ensure to pass on to service type
# @param user User to run the service as.
# @param group Group to run the service as.
# @param listen What IP/port to listen on for API requests.
# @param log Enable or disable Upstart logging.
# @param enable_cli_and_http Enable concurrent use of command line (CLI) and HTTP APIs with the same Aptly root.
#
class aptly::api (
  Enum['stopped','running'] $ensure = running,
  String[1] $user                   = 'root',
  String[1] $group                  = 'root',
  Pattern['^([0-9.]*:[0-9]+$|unix:)'] $listen = ':8080',
  Enum['none','log'] $log           = 'none',
  Boolean $enable_cli_and_http      = false,
) {
  file { 'aptly-systemd':
    path    => '/etc/systemd/system/aptly-api.service',
    content => template('aptly/etc/aptly-api.systemd.erb'),
  }
  ~> exec { 'aptly-api-systemd-reload':
    command     => 'systemctl daemon-reload',
    path        => ['/usr/bin', '/bin', '/usr/sbin'],
    refreshonly => true,
    notify      => Service['aptly-api'],
  }

  service { 'aptly-api':
    ensure => $ensure,
    enable => true,
  }
}
