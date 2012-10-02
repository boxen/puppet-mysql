define mysql::db($ensure = present) {
  require mysql

  exec { "mysql-db-${name}":
    command => "mysqladmin -uroot create ${name}",
    creates => "${mysql::config::datadir}/${name}",
    require => Exec['wait-for-mysql']
  }
}
