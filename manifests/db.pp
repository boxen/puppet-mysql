# Public: Create MySQL Databases
#
# namevar - The name of the database.
#
# Examples
#
#   mysql::db { 'foo': }
define mysql::db(
  $ensure = present
) {
  require mysql

  if $ensure == 'present' {
    exec { "create mysql db ${name}":
      command => "mysqladmin -h${host} -uroot -p${port} create ${name} --password=''",
      creates => "${mysql::datadir}/${name}",
      unless  => "mysql -h${host} -uroot -p${port} -e 'show databases' \
        --password='' | grep -w '${name}'"
    }
  } elsif $ensure == 'absent' {
    exec { "delete mysql db ${name}":
      command => "mysqladmin -h${host} -uroot -p${port} drop ${name} --password=''",
    }
  }
}
