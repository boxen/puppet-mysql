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
  $bindir = undef,
  $executable = undef,
  $client = undef,
  $logdir = undef,
  $servicename = undef,

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
    $bindir,
    $executable,
    $client,
    $logdir,
    $servicename,
    $user,
    $host,
    $port,
    $socket,
    $package,
    $version,
  )

  validate_bool(str2bool($enable))

  class { 'mysql::package':
    ensure  => $ensure,
    version => $version,
    package => $package,
  }

  ~>
  class { 'mysql::config':
    ensure             => $ensure,

    configdir          => $configdir,
    bindir             => $bindir,
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
    ensure      => $ensure,
    enable      => str2bool($enable),
    servicename => $servicename,
  }

  ~>
  class { 'mysql::setup':
    bindir  => $bindir,
    datadir => $datadir,
    host    => $host,
    port    => $port,
    socket  => $socket,
  }

  -> Mysql::Db <| |>

  Mysql::User <| |> -> Mysql::User::Grant <| |>
}
