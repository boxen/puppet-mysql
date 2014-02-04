class mysql::service(
  $ensure      = undef,
  $enable      = undef,
  $servicename = undef,
) {

  $real_ensure = $ensure ? {
    present => running,
    default => stopped,
  }

  service { $servicename:
    ensure => $real_ensure,
    enable => $enable,
    alias  => 'mysql',
  }

  if $osfamily == 'Darwin' {
    service { 'com.boxen.mysql': # replaced by dev.mysql
      before => Service['mysql'],
      enable => false
    }
  }

}
