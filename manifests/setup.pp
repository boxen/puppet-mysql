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
  ~>  exec { 'mysql-set-root-password':
    command => "mysqladmin -u root -p'' password ${mysql::rootpwd}",
    onlyif  => "mysql -uroot -ppassword -e ''; test $? != 0",
  }
  ~>
  exec { 'grant root user privileges':
    command     => "${bindir}/mysql -uroot -p${mysql::rootpwd} -h${host} -P${port} -S${socket} \
      -e \"grant all privileges on *.* to 'root'@'%' identified by '${mysql::rootpwd}' with grant option; grant all privileges on *.* to 'root'@'localhost' identified by '${mysql::rootpwd}' with grant option;flush privileges;\"",
    unless      => "${bindir}/mysql -uroot -h${host} -P${port} \
      -e \"select * from mysql.user where User = 'root' and Host = '%'\" \
      --password=${mysql::rootpwd} | grep root",
    provider    => shell,
    refreshonly => true
  }
  ~>
  exec { 'mysql-tzinfo-to-sql':
    command     => "${bindir}/mysql_tzinfo_to_sql /usr/share/zoneinfo | \
      ${bindir}/mysql -u root mysql -h${host} -P${port} -S${socket} -p${mysql::rootpwd}",
    provider    => shell,
    creates     => "${datadir}/.tz_info_created",
    refreshonly => true
  }

}
