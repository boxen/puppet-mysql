class mysql::service(
  $ensure = $mysql::params::ensure,
  $enable = $mysql::params::enable,
) inherits mysql::params {

  $real_ensure = $ensure ? {
    present => running,
    default => stopped,
  }

  service { 'dev.mysql':
    ensure => $real_ensure,
    enable => $enable,
    alias  => 'mysql',
  }

  service { 'com.boxen.mysql': # replaced by dev.mysql
    before => Service['dev.mysql'],
    enable => false
  }

}
