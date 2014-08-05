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

## Versioning (5.5.20 vs 5.6.20)

This version module doesn't support simultaneous installation of 5.6 and 5.5,
but both brews are kept here for reference. Choose your destiny via symlink.

Current: `readlink files/brews/mysql.rb ===> mysql56.rb`

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
