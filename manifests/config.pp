# Internal: Prepare your system for MySQL.
#
# Examples
#
#   include mysql::config
class mysql::config(
  $port       = 13306
) {
  require boxen::config

  $bindir     = "${boxen::config::homebrewdir}/bin"
  $configdir  = "${boxen::config::configdir}/mysql"
  $configfile = "${configdir}/my.cnf"
  $datadir    = "${boxen::config::datadir}/mysql"
  $executable = "${bindir}/mysqld_safe"
  $logdir     = "${boxen::config::logdir}/mysql"
  $logerror   = "${logdir}/error.log"
  $socket     = "${datadir}/socket"
}
