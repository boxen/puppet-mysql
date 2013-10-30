class mysql::params {
  case $::operatingsystem {
    Darwin: {
      include boxen::config

      $ensure             = present

      $configdir          = "${boxen::config::configdir}/mysql"
      $globalconfigprefix = $boxen::config::homebrewdir
      $datadir            = "${boxen::config::datadir}/mysql"
      $executable         = "${boxen::config::homebrewdir}/bin/mysqld_safe"
      $logdir             = "${boxen::config::logdir}/mysql"

      $user               = $::boxen_user
      $host               = 'localhost'
      $port               = 13306
      $socket             = "${datadir}/socket"

      $package            = 'boxen/brews/mysql'
      $version            = '5.5.20-boxen2'

      $enable             = true
    }

    default: {
      fail("Unsupported operating system")
    }
  }

}
