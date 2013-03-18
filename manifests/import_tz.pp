define mysql::import_tz {
  require mysql

  exec { "import timezone data":
    command => "mysql_tzinfo_to_sql /usr/share/zoneinfo/ | mysql -h 127.0.0.1 -u root mysql"
    require => Exec['wait-for-mysql']
  }
}