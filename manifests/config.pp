# Internal: Prepare your system for MySQL.
#
# Examples
#
#   include mysql::config

class mysql::config(
  $ensure             = $mysql::params::ensure,

  $configdir          = $mysql::params::configdir,
  $globalconfigprefix = $mysql::params::globalconfigprefix,
  $datadir            = $mysql::params::datadir,
  $executable         = $mysql::params::executable,

  $logdir             = $mysql::params::logdir,

  $host               = $mysql::params::host,
  $port               = $mysql::params::port,
  $socket             = $mysql::params::socket,
  $user               = $mysql::params::user,
) inherits mysql::params {

  file {
    [
      $configdir,
      $datadir,
      $logdir,
    ]:
      ensure => directory ;

    "${configdir}/my.cnf":
      content => template('mysql/my.cnf.erb') ;

    "${globalconfigprefix}/etc/my.cnf":
      ensure  => link,
      target  => "${configdir}/my.cnf" ;

    '/Library/LaunchDaemons/dev.mysql.plist':
      content => template('mysql/dev.mysql.plist.erb'),
      group   => 'wheel',
      owner   => 'root' ;

    "${globalconfigprefix}/var/mysql":
      ensure  => absent,
      force   => true,
      recurse => true ;

    "${boxen::config::envdir}/mysql.sh":
      ensure => absent,
  }

  ->
  exec { 'init-mysql-db':
    command  => "mysql_install_db \
      --verbose \
      --basedir=${globalconfigprefix} \
      --datadir=${datadir} \
      --tmpdir=/tmp",
    creates  => "${datadir}/mysql",
    provider => shell,
  }

  ->
  boxen::env_script { 'mysql':
    ensure   => $ensure,
    content  => template('mysql/env.sh.erb'),
    priority => 'higher',
  }

}
