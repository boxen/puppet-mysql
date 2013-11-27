# Public: Install MySQL
#
# Examples
#
#   include mysql
class mysql(
  $ensure             = $mysql::params::ensure,

  $configdir          = $mysql::params::configdir,
  $globalconfigprefix = $mysql::params::globalconfigprefix,
  $datadir            = $mysql::params::datadir,
  $executable         = $mysql::params::executable,
  $logdir             = $mysql::params::logdir,

  $user               = $mysql::params::user,
  $host               = $mysql::params::host,
  $port               = $mysql::params::port,
  $socket             = $mysql::params::socket,

  $package            = $mysql::params::package,
  $version            = $mysql::params::version,

  $enable             = $mysql::params::enable,

) inherits mysql::params {

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
}
