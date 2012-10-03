class mysql::config {
  require boxen::config

  $configdir  = "${boxen::config::configdir}/mysql"
  $configfile = "${configdir}/my.cnf"
  $datadir    = "${boxen::config::datadir}/mysql"
  $executable = "${boxen::config::homebrewdir}/bin/mysqld_safe"
  $logdir     = "${boxen::config::logdir}/mysql"
  $logerror   = "${logdir}/error.log"
  $port       = 13306
  $socket     = "${datadir}/socket"

  file { [$configdir, $datadir, $logdir]:
    ensure => directory
  }

  file { $configfile:
    content => template('mysql/my.cnf.erb'),
    notify  => Service['com.boxen.mysql'],
  }

  file { "${boxen::config::homebrewdir}/etc/my.cnf":
    ensure  => link,
    require => [File[$configfile], Class['homebrew']],
    target  => $configfile
  }

  file { '/Library/LaunchDaemons/com.boxen.mysql.plist':
    content => template('mysql/com.boxen.mysql.plist.erb'),
    group   => 'wheel',
    notify  => Service['com.boxen.mysql'],
    owner   => 'root'
  }
}
