class mysql {
  require mysql::config

  package { 'boxen/brews/mysql':
    ensure => '5.5.20-boxen2',
    notify => Service['dev.mysql']
  }

  file { "${boxen::config::homebrewdir}/var/mysql":
    ensure  => absent,
    force   => true,
    recurse => true
  }

  exec { 'init-mysql-db':
    command  => "mysql_install_db \
      --verbose \
      --basedir=${boxen::config::homebrewdir} \
      --datadir=${mysql::config::datadir} \
      --tmpdir=/tmp",

    creates  => "${mysql::config::datadir}/mysql",
    provider => shell
  }

  service { 'dev.mysql':
    ensure => running,
    notify => Exec['wait-for-mysql']
  }

  service { 'com.boxen.mysql': # replaced by dev.mysql
    before => Service['dev.mysql'],
    enable => false
  }

  file { "${boxen::config::envdir}/mysql.sh":
    content => template('mysql/env.sh.erb'),
    require => File[$boxen::config::envdir]
  }

  $nc = "/usr/bin/nc -z localhost ${mysql::config::port}"

  exec { 'wait-for-mysql':
    command     => "while ! ${nc}; do sleep 1; done",
    provider    => shell,
    timeout     => 30,
    refreshonly => true
  }

  Package['boxen/brews/mysql'] ->
    File["${boxen::config::homebrewdir}/var/mysql"]
    Exec['init-mysql-db'] ->
    Service['dev.mysql'] ->
    Exec['wait-for-mysql']
}
