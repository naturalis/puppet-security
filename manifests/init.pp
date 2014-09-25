# == Class: security
#
# Full description of class security here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'security':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class security (
  $securitypackage = undef,
  $security_status = 'latest',
  $once_lock       = "/var/lock/puppet-once",
  ) {

# Default setting for exec command
  Exec {
    refreshonly => true,
  }

# Make sure exec commands only run once
  exec { 'run-once-commands':
    command => "touch $once_lock",
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
        command                       => '/usr/binyum update',
    }
    package { '$securitypackage':
      ensure                          => '$security_status',
      require                         => Exec['yum update'],
    }
  }
  'default': {
    notify { "Security fixes are not working on '$operatingsystem' - '$operatingsystemrelease' is not supported": }
  }
}
}
