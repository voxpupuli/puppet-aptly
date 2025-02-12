# Aptly Puppet Module

[![Build Status](https://github.com/voxpupuli/puppet-aptly/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-aptly/actions?query=workflow%3ACI)
[![Release](https://github.com/voxpupuli/puppet-aptly/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-aptly/actions/workflows/release.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/aptly.svg)](https://forge.puppetlabs.com/puppet/aptly)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/aptly.svg)](https://forge.puppetlabs.com/puppet/aptly)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/aptly.svg)](https://forge.puppetlabs.com/puppet/aptly)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/aptly.svg)](https://forge.puppetlabs.com/puppet/aptly)
[![puppetmodule.info docs](http://www.puppetmodule.info/images/badge.png)](http://www.puppetmodule.info/m/puppet-aptly)
[![MIT License](https://img.shields.io/github/license/voxpupuli/puppet-aptly.svg)](LICENSE)
[![Forked from GDS](https://img.shields.io/badge/donated%20by-GDS-fb7047.svg)](#transfer-notice)

# aptly
Puppet module for [aptly](https://www.aptly.info/).

## Example usage

You need to include the `apt` module if you wish to install it
out-of-the-box.

```puppet
include apt
```

Include with default parameters:

```puppet
include aptly
```

Create a mirror for manual update/snapshot/publish:

```puppet
aptly::mirror { 'puppetlabs':
  location => 'http://apt.puppetlabs.com/',
  repos    => ['main', 'dependencies'],
  key      => '4BD6EC30',
}
```
or with the [puppetlabs/apt](https://forge.puppet.com/puppetlabs/apt)  module 2.0+ format

```puppet
aptly::mirror { 'puppetlabs':
  location => 'http://apt.puppetlabs.com/',
  repos    => ['main', 'dependencies'],
  key      => {
    server => 'keyserver.ubuntu.com',
    id     => '4BD6EC30',
  }
}
```

Create an aptly repository to host local packages:

```puppet
aptly::repo { 'mylocalrepo': }
```

See the class and defined type documentation for advanced usage.

## License

See [LICENSE](LICENSE) file.

## Transfer Notice

This module was originalle maintained by Government Digital Service (GDS) at [github.com/alphagov/puppet-aptly](https://github.com/alphagov/puppet-aptly)
