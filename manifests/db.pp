# Public: Create MySQL Databases
#
# namevar - The name of the database.
#
# Examples
#
#   mysql::db { 'foo': }
define mysql::db($ensure = present) {
  require mysql

  if $ensure == 'present' {
    exec { "create mysql db ${name}":
      command => "mysqladmin -uroot -p${mysql::config::port} create ${name} --password=''",
      creates => "${mysql::config::datadir}/${name}",
      require => Exec['wait-for-mysql'],
      unless  => "mysql -uroot -p${mysql::config::port} -e 'show databases' \
        --password='' | grep -w '${name}'"
    }
  } elsif $ensure == 'absent' {
    exec { "delete mysql db ${name}":
      command => "mysqladmin -uroot -p${mysql::config::port} drop ${name} --password=''",
      require => Exec['wait-for-mysql']
    }
  }
}
