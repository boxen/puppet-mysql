# Public: Install MySQL
#
# Examples
#
#   include mysql
class mysql(
  $ensure = undef,
  $enable = undef,

  $configdir = undef,
  $globalconfigprefix = undef,
  $datadir = undef,
  $executable = undef,
  $logdir = undef,

  $user = undef,
  $host = undef,
  $port = undef,
  $socket = undef,

  $package = undef,
  $version = undef,
) {
  include boxen::config

  validate_string(
    $ensure,
    $configdir,
    $globalconfigprefix,
    $datadir,
    $executable,
    $logdir,
    $user,
    $host,
    $port,
    $socket,
    $package,
    $version
  )

  validate_bool($enable)

  class { 'mysql::package':
    ensure  => $ensure,
    version => $version,
    package => $package,
  }

  ~>
  class { 'mysql::config':
    ensure             => $ensure,

    configdir          => $configdir,
    globalconfigprefix => $globalconfigprefix,
    datadir            => $datadir,
    executable         => $executable,

    logdir             => $logdir,

    host               => $host,
    port               => $port,
    socket             => $socket,
    user               => $user,

    notify             => Service['mysql'],
  }

  ~>
  class { 'mysql::service':
    ensure => $ensure,
    enable => $enable,
  }

  ~>
  class { 'mysql::setup':
    datadir => $datadir,
    host    => $host,
    port    => $port,
    socket  => $socket,
  }

  -> Mysql::Db <| |>

  Mysql::User <| |> -> Mysql::User::Grant <| |>
}
