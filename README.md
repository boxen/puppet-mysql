# MySQL Puppet Module for Boxen

Requires the following boxen modules:

* `boxen`

## Usage

```puppet
include mysql

mysql::db { 'mydb': }
```

### Environment

Once installed, you can access the following variables in your environment, projects, etc:

* BOXEN_MYSQL_PORT: the configured MySQL port
* BOXEN_MYSQL_URL: the URL for MySQL, including localhost & port
* BOXEN_MYSQL_SOCKET: the path to the MySQL socket

#### Rails

In config/database.yml:

```yaml
development:
  adapter: mysql3
  database: yourapp_development
  username: root
  password:
  port: <%= ENV['BOXEN_MYSQL_PORT'] || 3306 %>

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  adapter: mysql2
  database: yourapp_test
  username: root
  port: <%= ENV['BOXEN_MYSQL_PORT'] || 3306 %>
```

## Developing

Write code.

Run `script/cibuild`.
