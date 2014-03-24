class owncloud::params {
	$owncloud_package_basepath='puppet:///modules/owncloud/files/owncloud-%s.tar.bz2'
  case $::osfamily {
    Debian: {
      $nginx_pkgn = 'nginx'
      $prerequisite_packages = ['libav-tools','smbclient']
    }
    /*RedHat: {
      $ssh_package_name = 'openssh-server'
    }*/
    default: {
      fail("Module propuppet-ssh does not support osfamily: ${::osfamily}")
    }
  }

}