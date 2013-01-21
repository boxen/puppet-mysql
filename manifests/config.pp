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
    notify  => Service['dev.mysql'],
  }

  file { "${boxen::config::homebrewdir}/etc/my.cnf":
    ensure  => link,
    require => [File[$configfile], Class['homebrew']],
    target  => $configfile
  }

  file { '/Library/LaunchDaemons/dev.mysql.plist':
    content => template('mysql/dev.mysql.plist.erb'),
    group   => 'wheel',
    notify  => Service['dev.mysql'],
    owner   => 'root'
  }
}
