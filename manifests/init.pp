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

  case $operatingsystem {
    'Ubuntu': {
      exec { 'apt-get update':
        command               => '/usr/bin/apt-get update',
        unless                => '/usr/bin/test -f /var/lock/puppet-once',
      }
      package { $securitypackage:
        ensure                => $security_status,
        require               => Exec['apt-get update'],
        notify                => Exec['run-once-commands'],
      }
      exec { 'run-once-commands':
        command               => '/usr/bin/touch /var/lock/puppet-once',
        refreshonly           => true,
        creates               => '/var/lock/puppet-once',
        subscribe             => Package[$securitypackage],
      }
    }
    'CentOS': {
      exec { 'yum update':
        command               => '/usr/bin/yum -y -q update',
        unless                => '/usr/bin/test -f /var/lock/puppet-once',
      }
      package { $securitypackage:
        ensure                => $security_status,
        require               => Exec['yum update'],
        notify                => Exec['run-once-commands'],
      }
      exec { 'run-once-commands':
        command               => '/bin/touch /var/lock/puppet-once',
        refreshonly           => true,
        creates               => '/var/lock/puppet-once',
        subscribe             => Package[$securitypackage],
      }
    }
  'default': {
    notify { "Security fixes on '$operatingsystem' - '$operatingsystemrelease' are not supported": }
  }
}
}
}
