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
      command => "mysqladmin -uroot create ${name}",
      creates => "${mysql::config::datadir}/${name}",
      require => Exec['wait-for-mysql']
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
      command => "mysqladmin -uroot drop database ${name}",
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
