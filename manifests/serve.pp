#
# @summary Install and configure Aptly's static file server (aptly serve)
#
# @param ensure Ensure to pass on to service type
# @param user User to run the service as.
# @param group Group to run the service as.
# @param listen What IP/port to listen on for HTTP requests.
# @param config_file Absolute path to the Aptly configuration file.
#
class aptly::serve (
  Enum['stopped','running'] $ensure           = running,
  String[1] $user                             = 'root',
  String[1] $group                            = 'root',
  Pattern['^([0-9.]*:[0-9]+$|unix:)'] $listen = ':8080',
  Stdlib::Absolutepath $config_file           = '/etc/aptly.conf',
) {
  $description = 'Aptly-serve'
  $exec_start  = "/usr/bin/aptly serve -listen=${listen} -config=${config_file}"

  systemd::unit_file { 'aptly-serve.service':
    content => template('aptly/etc/aptly.service.systemd.erb'),
    active  => $ensure == 'running',
    enable  => $ensure == 'running',
  }
}
