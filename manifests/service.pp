class mysql::service(
  $ensure      = undef,
  $enable      = undef,
  $servicename = undef,
) {

  $real_ensure = $ensure ? {
    present => running,
    default => stopped,
  }

  if $::osfamily == 'Debian' {
    file { "/etc/init.d/${servicename}":
      ensure => 'file',
      source => 'puppet:///mysql/mysql.server',
      before => Service['mysql'],
    }
  }

  $provider = $::osfamily ? {
    'Debian' => 'init',
    default  => undef,
  }

  service { $servicename:
    ensure   => $real_ensure,
    enable   => $enable,
    provider => $provider,
    alias    => 'mysql',
  }

  if $osfamily == 'Darwin' {
    service { 'com.boxen.mysql': # replaced by dev.mysql
      before => Service['mysql'],
      enable => false
    }
  }

}
