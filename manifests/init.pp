# == Class: security
#
# Security fixes will be pushed by this module.
#
# === Copyright
#
# Copyright 2014
#
class security (
  $securitypackage            = 'none',
  $security_status            = 'latest',
  ) {

  if $securitypackage == 'none' {
    file {'puppet-once':
      ensure                  => absent,
      path                    => '/var/lock/puppet-once',
    }
  }
  else {
  Exec {
    refreshonly               => true,
  }
  case $operatingsystem {
    'Ubuntu': {
      exec { 'apt-get update':
        command               => '/usr/bin/apt-get update',
        onlyif                => 'test ! -f /var/lock/puppet-once',
      }
      package { $securitypackage:
        ensure                => $security_status,
        require               => Exec['apt-get update'],
        onlyif                => 'test ! -f /var/lock/puppet-once',
        notify                => Exec['run-once-commands'],
      }
      exec { 'run-once-commands':
        command               => '/usr/bin/touch /var/lock/puppet-once',
        creates               => '/var/lock/puppet-once',
        require               => Package[$securitypackage],
      }
    }
    'CentOS': {
      exec { 'yum update':
        command               => '/usr/bin/yum update',
        onlyif                => 'test ! -f /var/lock/puppet-once',
      }
      package { $securitypackage:
        ensure                => $security_status,
        require               => Exec['yum update'],
        onlyif                => 'test ! -f /var/lock/puppet-once',
        notify                => Exec['run-once-commands'],
      }
      exec { 'run-once-commands':
        command               => '/bin/touch /var/lock/puppet-once',
        creates               => '/var/lock/puppet-once',
        require               => Package[$securitypackage],
      }
    }
  'default': {
    notify { "Security fixes on '$operatingsystem' - '$operatingsystemrelease' are not supported": }
  }
}
}
}
