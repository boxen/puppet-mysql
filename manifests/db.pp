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
      command => "${mysql::bindir}/mysqladmin -h${mysql::host} -uroot -p${mysql::port} create ${name} --password=''",
      creates => "${mysql::datadir}/${name}",
      unless  => "${mysql::bindir}/mysql -h${mysql::host} -uroot -p${mysql::port} -e 'show databases' \
        --password='' | grep -w '${name}'"
    }
  } elsif $ensure == 'absent' {
    exec { "delete mysql db ${name}":
      command => "${mysql::bindir}/mysqladmin -h${mysql::host} -uroot -p${mysql::port} drop ${name} --password=''",
    }
  }
}
