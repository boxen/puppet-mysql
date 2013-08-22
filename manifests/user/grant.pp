# Public: Sets a MySQL Grant
#
# namevar - The database to grant access to
# username - the username of the user.
# readonly - If the user should be read-only. Defaults to false
# host - host to permit access from. Defaults to 'localhost'
#
# Examples
#
#   mysql::user { 'foo': }

define mysql::user::grant($username, $host = 'localhost', $readonly = false) {
  if $readonly {
    $grants = 'SELECT, LOCK TABLES, CREATE TEMPORARY TABLES'
  } else {
    $grants = 'ALL'
  }
  require mysql

  exec { "granting ${username} access to ${name}":
    command => "mysql -uroot -p13306 --password=''\
       -e \"grant ${grants} on ${name}.* to '${username}'@'${host}'; flush privileges;\"",
    require => Exec['wait-for-mysql'],
    unless  => "mysql -uroot -p13306 -e 'SHOW GRANTS;' \
      --password='' | grep -w '${name}' | grep -w '${username}' \
      | grep -w '${host}' | grep -w '#{grants}'"
  }
}
