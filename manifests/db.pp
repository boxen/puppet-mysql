# Public: Create MySQL Databases
#
# namevar - The name of the database.
#
# Examples
#
#   mysql::db { 'foo': }
define mysql::db($ensure = present, $user = absent, $password = 'password', $host = '%', $grant = 'ALL') {
  require mysql

  if $ensure == 'present' {
    exec { "create mysql db ${name}":
      command => "mysqladmin -uroot -p13306 create ${name} --password=''",
      creates => "${mysql::config::datadir}/${name}",
      require => Exec['wait-for-mysql'],
      unless  => "mysql -uroot -p13306 -e 'show databases' \
        --password='' | grep -w '${name}'"
    }

    if $user != 'absent' {
      exec { "create user ${user} with ${grant} permissions on ${host} to ${name}":
        command => "mysql -uroot -e \"\
 GRANT ${grant} PRIVILEGES ON ${name} . * TO '${user}'@'${host}' IDENTIFIED BY '${password}';\
 GRANT ${grant} PRIVILEGES ON ${name} . * TO '${user}'@'localhost' IDENTIFIED BY '${password}';\
 FLUSH PRIVILEGES;\"",
        require => Exec['wait-for-mysql']
      }
    }

  } elsif $ensure == 'absent' {
    exec { "delete mysql db ${name}":
      command => "mysqladmin -uroot -p13306 drop ${name} --password=''",
      require => Exec['wait-for-mysql']
    }

    if $user != 'absent' {
      exec { "drop user ${user}@${host}":
        command => "mysql -uroot -e \"\
 GRANT USAGE ON *.* TO '${user}'@'${host}'; DROP USER '${user}'@'${host}';\
 GRANT USAGE ON *.* TO '${user}'@'localhost'; DROP USER '${user}'@'localhost';\
 FLUSH PRIVILEGES;\"",
        require => Exec['wait-for-mysql']
      }
    }

  }
}
