# security

#### Table of Contents

1. [Overview](#overview)
2. [Parameters - What parameters does the module use](#parameters)
3. [Limitations - OS compatibility, etc.](#limitations)
4. [Dependencies - The dependencies this module has](#dependencies)

## Overview

Security fixes will be pushed by this module.

## Parameters
-------------
All parameters are read from defaults in init.pp and can be overwritten by The Foreman.

```
$securitypackage                    = undef,
$security_status                    = 'latest',

```
## Limitations

This module has been built on and tested against Puppet 3.2.3 and higher.

The module has been tested on
- Ubuntu Server 12.04, 14.04
- Centos 6.4, 6.5

## Dependencies
-------------
- stdlib
