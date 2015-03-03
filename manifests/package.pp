# A Homebrew installation of MySQL (and no-op on non-OSX platforms)
class mysql::package(
  $ensure  = $mysql::params::ensure,
  $version = $mysql::params::version,
  $package = $mysql::params::package,
) inherits mysql::params {

  $real_ensure = $ensure ? {
    present => $version,
    default => absent,
  }

  case $::operatingsystem {
    Darwin: {
      require homebrew

      homebrew::formula { 'mysql': }
    }

    default: {
      #noop
    }
  }

  package { $package:
    ensure => $real_ensure,
  }

}
