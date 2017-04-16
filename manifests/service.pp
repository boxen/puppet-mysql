# The running MySQL daemon
class mysql::service(
  $ensure      = undef,
  $enable      = undef,
  $servicename = undef,
) {

  $real_ensure = $ensure ? {
    present => running,
    default => stopped,
  }

  if $::osfamily == 'Darwin' {
    file { "/Library/LaunchDaemons/${servicename}.plist":
      content => template('mysql/dev.mysql.plist.erb'),
      owner   => 'root',
      group   => 'wheel',
      before  => Service[$servicename],
    }
  }

  if $::osfamily == 'Darwin' {
    service { $servicename:
      ensure   => $real_ensure,
      enable   => $enable,
      provider => $provider,
      alias    => 'mysql',
      # Hardcode -w because Puppet's detection of when it is needed is
      # sometimes flaky which causes MySQL to not restart.
      start    => "launchctl load -w /Library/LaunchDaemons/${servicename}.plist",
    }

    service { 'com.boxen.mysql': # replaced by dev.mysql
      before => Service[$servicename],
      enable => false
    }
  }
  else {
    service { $servicename:
      ensure   => $real_ensure,
      enable   => $enable,
      provider => $provider,
      alias    => 'mysql',
    }
  }
}
