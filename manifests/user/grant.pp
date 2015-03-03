# Public: Sets a MySQL Grant
#
# database - the name of the database to give access to
# username - the username of the user.
# readonly - If the user should be read-only. Defaults to false
# host - host to permit access from. Defaults to 'localhost'
#
# Examples
#
#   mysql::user { 'foo': }

define mysql::user::grant(
  $database,
  $username,
  $ensure   = present,
  $host     = 'localhost',
  $readonly = false
) {

  if $readonly {
    $grants = [
      'SELECT',
      'LOCK TABLES',
      'CREATE TEMPORARY TABLES',
    ]
  } else {
    $grants = 'ALL'
  }
  require mysql

  mysql_grant { $name:
    ensure     => $ensure,
    username   => $username,
    host       => $host,
    database   => $database,
    grants     => $grants,
    mysql_user => 'root',
    mysql_pass => '',
    mysql_host => $mysql::host,
    mysql_port => $mysql::port,
    executable => $mysql::client,
    require    => Exec['wait-for-mysql'],
  }
}
