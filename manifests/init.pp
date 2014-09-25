# == Class: security
#
# Security fixes will be pushed by this module.
#
# === Copyright
#
# Copyright 2014
#
class security (
  $securitypackage = undef,
  $security_status = 'latest',
  $once_lock       = '/var/lock/puppet-once',
  ) {

if defined($securitypackage) {

# Default setting for exec command
  Exec {
    refreshonly => true,
  }

# Make sure exec commands only run once
  exec { 'run-once-commands':
    command => "touch ${once_lock}",
    creates => $once_lock,
    notify  => [Exec['apt-get update'],
                Exec['yum update']],
  }

  case $operatingsystem {
    'Ubuntu': {
      exec { 'apt-get update':
        command                         => '/usr/bin/apt-get update',
      }
      package { '$securitypackage':
        ensure                          => '$security_status',
        require                         => Exec['apt-get update'],
      }
    }
    'CentOS': {
      exec { 'yum update':
        command                       => '/usr/bin/yum update',
      }
      package { '$securitypackage':
        ensure                          => '$security_status',
        require                         => Exec['yum update'],
      }
    }
  'default': {
    notify { "Security fixes on '$operatingsystem' - '$operatingsystemrelease' are not supported": }
  }
  }
}
else {
  file {'$once_lock':
    ensure  => absent,
    path    => '$once_lock',
  }
}
}
