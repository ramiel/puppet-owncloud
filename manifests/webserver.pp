#
class owncloud::webserver {
  include owncloud::params

  $version = $::owncloud::version
  $hostname = $::owncloud::hostname
  $installation_path = $::owncloud::installation_path
  $owncloud_package_basepath=$::owncloud::params::owncloud_package_basepath

  archive { 'owncloud':
    ensure    => present,
    url       => sprintf($owncloud_package_basepath,$version),
    extension => 'tar.bz2',
    target    => '/var/www'
  }

  file { '/var/www/owncloud' :
      ensure  => directory,
      owner   => root,
      group   => www-data,
      recurse => true,
      require => Archive['owncloud']
    }

  if $installation_path != '/var/www/owncloud' {

    file { 'installation_path' :
      ensure  => link,
      path    => $installation_path,
      source  => '/var/www/owncloud',
      owner   => root,
      group   => www-data,
      require => file['/var/www/owncloud']
    }

  }

  #Pre-requisites
  package { $::owncloud::params::prerequisite_packages:
    ensure => installed,
  }

  #PHP
  class { 'php':
    service => 'nginx'
  }

  php::module { [
      'mysql',
      'curl',
      'mcrypt',
      'ldap',
      #'ftp',
      'imagick',
      'fpm'
    ]:}

  class { 'nginx': }

  nginx::resource::vhost { $hostname :
    ensure   => present,
    www_root => $installation_path,
  }
}