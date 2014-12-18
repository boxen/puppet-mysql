# Public: Create MySQL User
#
# namevar - The name of the user.
# password - Password for the new user. Defaults to empty
# readonly - If the user should be read-only. Defaults to false
# databases - Databases to grant access to. Defaults to [].
# host - host to permit access from. Defaults to 'localhost'
#
# Examples
#
#   mysql::user { 'foo': }
define mysql::user(
  $ensure   = present,
  $readonly = false,
  $host     = 'localhost',
  $password = '',
) {
  require mysql

  if $ensure == 'present' {
    exec { "create mysql user ${name}":
      command => "${mysql::bindir}/mysql -h${mysql::host} -uroot -p${mysql::port} --password=''\
        -e \"create user '${name}'@'${host}' identified by '${password}';\"",
      require => Exec['wait-for-mysql'],
      unless  => "${mysql::bindir}/mysql -h${mysql::host} -uroot -p${mysql::port} -e 'SELECT User,Host FROM mysql.user;' \
        --password='' | grep -w '${name}' | grep -w '${host}'"
    }
  } elsif $ensure == 'absent' {
    exec { "delete mysql user ${name}":
      command => "${mysql::bindir}/mysql -h${mysql::host} -uroot -p${mysql::port} --password='' -e 'drop user ${name}'",
      require => Exec['wait-for-mysql']
    }
  }
}
