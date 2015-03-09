# Internal: Prepare your system for MySQL.
#
# Examples
#
#   include mysql::config

class mysql::config(
  $ensure = undef,

  $configdir = undef,
  $bindir = undef,
  $globalconfigprefix = undef,
  $datadir = undef,
  $executable = undef,

  $logdir = undef,

  $host = undef,
  $port = undef,
  $socket = undef,
  $user = undef,
) {

  File {
    ensure => $ensure,
    owner  => $user,
  }

  file {
    [
      $configdir,
      $datadir,
      $logdir,
    ]:
      ensure => directory ;

    "${configdir}/my.cnf":
      content => template('mysql/my.cnf.erb'),
      notify  => Service['mysql'] ;
  }

  ->
  exec { 'init-mysql-db':
    command  => "${bindir}/mysql_install_db \
      --verbose \
      --basedir=${globalconfigprefix} \
      --datadir=${datadir} \
      --tmpdir=/tmp",
    creates  => "${datadir}/mysql",
    provider => shell,
    user     => $user,
  }

  ->
  boxen::env_script { 'mysql':
    ensure   => $ensure,
    content  => template('mysql/env.sh.erb'),
    priority => 'higher',
  }

  if $::osfamily == 'Darwin' {
    file {
    "${boxen::config::envdir}/mysql.sh":
      ensure => absent ;

    "${globalconfigprefix}/var/mysql":
      ensure  => absent,
      force   => true,
      recurse => true ;

    "${globalconfigprefix}/etc/my.cnf":
      ensure  => link,
      target  => "${configdir}/my.cnf" ;
    }
  }
}
