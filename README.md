# MySQL Puppet Module for Boxen
### ...with Enhancements for Betterment

[![Build Status](https://travis-ci.org/Betterment/puppet-mysql.png)](https://travis-ci.org/Betterment/puppet-mysql)

## Usage

```puppet
include mysql

mysql::db { 'mydb': }

mysql::user { 'myuser':
  password => 'mypassword'
}
```

## Betterment Configuration

[We've heavily customized our my.cnf for large index innodb.](https://github.com/Betterment/puppet-mysql/blob/master/templates/my.cnf.erb)

```
...
innodb_buffer_pool_size=512Mb
innodb_file_per_table
innodb_file_format = Barracuda
innodb_large_prefix
...
```

## Versioning (5.5.20 vs 5.6.20)

This version module doesn't support simultaneous installation of 5.6 and 5.5,
but both brews are kept here for reference. Choose your destiny via symlink.

```
  package { 'boxen/brews/mysql':
    ensure => '5.6.20-boxen2',
    notify => Service['dev.mysql']
  }
```

## Required Puppet Modules

* boxen
* homebrew
* stdlib

## Environment

Call us crazy; we still run @ `localhost:3306`. ~~**ATTENTION** Boxen uses a non standard **13306** port to avoid collisions.~~

Once installed, you can access the following variables in your environment, projects, etc:

* BOXEN_MYSQL_PORT: the configured MySQL port
* BOXEN_MYSQL_URL: the URL for MySQL, including localhost & port
* BOXEN_MYSQL_SOCKET: the path to the MySQL socket

## Developing

Write code.

Run `script/cibuild`.
