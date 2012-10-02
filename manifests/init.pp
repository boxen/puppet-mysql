class mysql {
  require mysql::config

  package { 'github/brews/mysql':
    ensure => '5.5.20-github2',
    notify => Service['com.github.mysql']
  }

  file { "${github::config::homebrewdir}/var/mysql":
    ensure  => absent,
    force   => true,
    recurse => true
  }

  exec { 'init-mysql-db':
    command  => "mysql_install_db \
      --verbose \
      --basedir=${github::config::homebrewdir} \
      --datadir=${mysql::config::datadir} \
      --tmpdir=/tmp",

    creates  => "${mysql::config::datadir}/mysql",
    provider => shell
  }

  service { 'com.github.mysql':
    ensure => running,
    notify => Exec['wait-for-mysql']
  }

  file { "${github::config::envdir}/mysql.sh":
    content => template('mysql/env.sh.erb'),
    require => File[$github::config::envdir]
  }

  exec { 'wait-for-mysql':
    command     => "while ! ${nc}; do sleep 1; done",
    provider    => shell,
    timeout     => 30,
    refreshonly => true
  }

  Package['github/brews/mysql'] ->
    File["${github::config::homebrewdir}/var/mysql"]
    Exec['init-mysql-db'] ->
    Service['com.github.mysql'] ->
    Exec['wait-for-mysql']
}
