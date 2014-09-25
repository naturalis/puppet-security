# == Class: security
#
# Security fixes will be pushed by this module.
#
# === Copyright
#
# Copyright 2014
#
class security (
  $securitypackage = 'none',
  $security_status = 'latest',
  ) {

  if $securitypackage == 'none' {
    file {'/var/lock/puppet-once':
      ensure  => absent,
      path    => '/var/lock/puppet-once',
    }
  }

  else {

# Default setting for exec command
  Exec {
    refreshonly => true,
  }

# Make sure exec commands only run once
  exec { 'run-once-commands':
    command => "touch /var/lock/puppet-once",
    creates => '/var/lock/puppet-once',
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
}
