class mysql::config {
  require github::config

  $configdir  = "${github::config::configdir}/mysql"
  $configfile = "${configdir}/my.cnf"
  $datadir    = "${github::config::datadir}/mysql"
  $executable = "${github::config::homebrewdir}/bin/mysqld_safe"
  $logdir     = "${github::config::logdir}/mysql"
  $logerror   = "${logdir}/error.log"
  $port       = 13306
  $socket     = "${datadir}/socket"

  file { [$configdir, $datadir, $logdir]:
    ensure => directory
  }

  file { $configfile:
    content => template('mysql/my.cnf.erb'),
    notify  => Service['com.github.mysql'],
  }

  file { "${github::config::homebrewdir}/etc/my.cnf":
    ensure  => link,
    require => [File[$configfile], Class['homebrew']],
    target  => $configfile
  }

  file { '/Library/LaunchDaemons/com.github.mysql.plist':
    content => template('mysql/com.github.mysql.plist.erb'),
    group   => 'wheel',
    notify  => Service['com.github.mysql'],
    owner   => 'root'
  }
}
