# Options for configuring MySQL
class mysql::setup (
  $bindir  = undef,
  $datadir = undef,
  $host    = undef,
  $port    = undef,
  $socket  = undef,
) {

  exec { 'wait-for-mysql':
    command     => "while ! /usr/bin/nc -z ${host} ${port}; do sleep 1; done",
    provider    => shell,
    timeout     => 30,
    refreshonly => true
  }

  ~>
  exec { 'mysql-tzinfo-to-sql':
    command     => "${bindir}/mysql_tzinfo_to_sql /usr/share/zoneinfo | \
      ${bindir}/mysql -u root mysql -h${host} -P${port} -S${socket}",
    provider    => shell,
    creates     => "${datadir}/.tz_info_created",
    refreshonly => true
  }

  ~>
  exec { 'grant root user privileges':
    command     => "${bindir}/mysql -uroot --password='' -h${host} -P${port} -S${socket} \
      -e 'grant all privileges on *.* to \'root\'@\'localhost\''",
    unless      => "${bindir}/mysql -uroot -h${host} -P${port} \
      -e \"select * from mysql.user where User = 'root' and Host = 'localhost'\" \
      --password='' | grep root",
    provider    => shell,
    refreshonly => true
  }

}
