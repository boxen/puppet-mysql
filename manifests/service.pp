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
      source => 'puppet:///modules/mysql/mysql.server',
      mode   => '0755',
      owner  => 'root',
      group  => 'root',
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
