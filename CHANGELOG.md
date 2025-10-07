# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v3.0.0](https://github.com/voxpupuli/puppet-aptly/tree/v3.0.0) (2025-10-07)

[Full Changelog](https://github.com/voxpupuli/puppet-aptly/compare/v2.3.0...v3.0.0)

**Breaking changes:**

- Require puppet 8 [\#65](https://github.com/voxpupuli/puppet-aptly/pull/65) ([bastelfreak](https://github.com/bastelfreak))
- aptly repo: Do not hardcode squeeze OS & Don't pull aptly repo key from keyserver [\#55](https://github.com/voxpupuli/puppet-aptly/pull/55) ([bastelfreak](https://github.com/bastelfreak))
- Drop EoL Ubuntu 20.04 support [\#50](https://github.com/voxpupuli/puppet-aptly/pull/50) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add Debian 13 support [\#63](https://github.com/voxpupuli/puppet-aptly/pull/63) ([bastelfreak](https://github.com/bastelfreak))
- aptly::mirror: Cleanup variable logic [\#53](https://github.com/voxpupuli/puppet-aptly/pull/53) ([bastelfreak](https://github.com/bastelfreak))
- Replace create\_resources\(\) with .each [\#52](https://github.com/voxpupuli/puppet-aptly/pull/52) ([bastelfreak](https://github.com/bastelfreak))
- $key\_server: Use FQDN datatype [\#51](https://github.com/voxpupuli/puppet-aptly/pull/51) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- Refactor CLI helper and tasks [\#58](https://github.com/voxpupuli/puppet-aptly/pull/58) ([jay7x](https://github.com/jay7x))

**Merged pull requests:**

- refactor: Make the CLI helper a Puppet eXtension [\#56](https://github.com/voxpupuli/puppet-aptly/pull/56) ([jay7x](https://github.com/jay7x))
- Add acceptance test for aptly version [\#54](https://github.com/voxpupuli/puppet-aptly/pull/54) ([bastelfreak](https://github.com/bastelfreak))

## [v2.3.0](https://github.com/voxpupuli/puppet-aptly/tree/v2.3.0) (2025-02-12)

[Full Changelog](https://github.com/voxpupuli/puppet-aptly/compare/v2.2.0...v2.3.0)

**Implemented enhancements:**

- aptly-api: Manage via puppet/systemd module [\#43](https://github.com/voxpupuli/puppet-aptly/pull/43) ([bastelfreak](https://github.com/bastelfreak))

## [v2.2.0](https://github.com/voxpupuli/puppet-aptly/tree/v2.2.0) (2025-02-11)

[Full Changelog](https://github.com/voxpupuli/puppet-aptly/compare/v2.1.0...v2.2.0)

**Implemented enhancements:**

- Drop unused upstart template [\#38](https://github.com/voxpupuli/puppet-aptly/pull/38) ([jay7x](https://github.com/jay7x))
- Add Ubuntu 24.04 [\#37](https://github.com/voxpupuli/puppet-aptly/pull/37) ([jay7x](https://github.com/jay7x))
- Drop upstart support, refactor unit tests [\#36](https://github.com/voxpupuli/puppet-aptly/pull/36) ([jay7x](https://github.com/jay7x))
- Add Aptly Bolt tasks [\#34](https://github.com/voxpupuli/puppet-aptly/pull/34) ([jay7x](https://github.com/jay7x))
- Add support for -force-components flag [\#30](https://github.com/voxpupuli/puppet-aptly/pull/30) ([mdechiaro](https://github.com/mdechiaro))

**Merged pull requests:**

- puppetlabs/apt: Allow 10.x [\#40](https://github.com/voxpupuli/puppet-aptly/pull/40) ([bastelfreak](https://github.com/bastelfreak))

## [v2.1.0](https://github.com/voxpupuli/puppet-aptly/tree/v2.1.0) (2024-02-27)

[Full Changelog](https://github.com/voxpupuli/puppet-aptly/compare/v2.0.0...v2.1.0)

**Implemented enhancements:**

- Add puppet-strings documentation [\#22](https://github.com/voxpupuli/puppet-aptly/pull/22) ([bastelfreak](https://github.com/bastelfreak))

## [v2.0.0](https://github.com/voxpupuli/puppet-aptly/tree/v2.0.0) (2024-02-27)

[Full Changelog](https://github.com/voxpupuli/puppet-aptly/compare/v1.0.0...v2.0.0)

**Breaking changes:**

- puppetlabs/apt: Require 9.x [\#15](https://github.com/voxpupuli/puppet-aptly/pull/15) ([bastelfreak](https://github.com/bastelfreak))
- Drop Ubuntu 12/14/16 support [\#11](https://github.com/voxpupuli/puppet-aptly/pull/11) ([bastelfreak](https://github.com/bastelfreak))
- Drop Puppet \< 7 support; Add Puppet 8 support [\#10](https://github.com/voxpupuli/puppet-aptly/pull/10) ([bastelfreak](https://github.com/bastelfreak))
- puppetlabs/stdlib: Require 9.x [\#7](https://github.com/voxpupuli/puppet-aptly/pull/7) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add Debian 11/12 support [\#20](https://github.com/voxpupuli/puppet-aptly/pull/20) ([bastelfreak](https://github.com/bastelfreak))
- Add basic acceptance tests [\#16](https://github.com/voxpupuli/puppet-aptly/pull/16) ([bastelfreak](https://github.com/bastelfreak))
- Add Ubuntu 20.04/22.04 support [\#12](https://github.com/voxpupuli/puppet-aptly/pull/12) ([bastelfreak](https://github.com/bastelfreak))
- mirror: param filter: default to undef [\#5](https://github.com/voxpupuli/puppet-aptly/pull/5) ([bastelfreak](https://github.com/bastelfreak))
- replace legacy is\_array/is\_string with native datatype checks [\#4](https://github.com/voxpupuli/puppet-aptly/pull/4) ([bastelfreak](https://github.com/bastelfreak))
- replace legacy validate\_\* functions with native datatypes [\#2](https://github.com/voxpupuli/puppet-aptly/pull/2) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- mirror: use proper $PATH for exec resource [\#19](https://github.com/voxpupuli/puppet-aptly/pull/19) ([bastelfreak](https://github.com/bastelfreak))
- Update repo.aptly.info gpg key [\#17](https://github.com/voxpupuli/puppet-aptly/pull/17) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- Add acceptance test for aptly::mirror [\#18](https://github.com/voxpupuli/puppet-aptly/pull/18) ([bastelfreak](https://github.com/bastelfreak))
- rubocop: autocorrect [\#14](https://github.com/voxpupuli/puppet-aptly/pull/14) ([bastelfreak](https://github.com/bastelfreak))
- README.md/CHANGELOG.md: Purge trailing whitespace [\#9](https://github.com/voxpupuli/puppet-aptly/pull/9) ([bastelfreak](https://github.com/bastelfreak))
- repo: parameters: default to undef [\#6](https://github.com/voxpupuli/puppet-aptly/pull/6) ([bastelfreak](https://github.com/bastelfreak))
- replace deprecated is\_hash with native datatype check [\#3](https://github.com/voxpupuli/puppet-aptly/pull/3) ([bastelfreak](https://github.com/bastelfreak))

## [v1.0.0](https://github.com/voxpupuli/puppet-aptly/tree/v1.0.0) (2019-01-28)

- Convertion to PDK
- Update Aptly repositories keys
- More validation
- Support of the [puppetlabs/apt](https://forge.puppet.com/puppetlabs/apt) module (version 2.0+) format of keys:
  - `aptly::mirror::keyserver` has been removed
  - `aptly::mirror::key` is now a string containing the key id or a hash (see example in [Readme](Readme.md))

2017-08-11 Release 0.9.0
- Add support for running on systemd based systems. Thanks to @zipkid for the code *and* tests!

2016-09-09 Release 0.8.0
- Add `filter` parameter (Thanks @trevorrea)
- Add `filter_with_deps` parameter (Thanks @trevorrea)
- Modified travis config to run tests with puppet 4.6

2016-06-14 Release 0.7.0
- Add `environment` parameter (thanks @zipkid)

2016-06-03 Release 0.6.0
- Support Ruby 2.1.0 and 2.2.0
- Support Puppet 3.8
- Stop testing Puppet 3.1, 3.2, 3.6 and 3.7
- Ensure that `apt::update` runs before installing aptly
- Add parameter for `-no-lock` option
- Update the aptly repository's GPG key

2016-02-26 Release 0.5.0
- Update support for puppetlabs/apt from version 1-2 to version 2-3
  (thanks @zxjinn)
- Do not run an exec to add a GPG key in `aptly::mirror` if no
  GPG key is provided (thanks @antonio)

2015-12-04 Release 0.4.0
- Drop support for Puppet 2.7 and for Puppet 3.1 but only on Ruby 2
- Start running tests against Puppet 3.6 and 3.7
- Add a defined type `aptly::snapshot` to create Aptly snapshots (thanks @mklette)
- Add `$architectures`, `$with_sources` and `$with_udebs` parameters to
  `aptly::mirror` (thanks @mklette and @dw-thomast)
- Add `$architectures`, `$comment` and `$distribution` parameters to
  `aptly::repo` (thanks @mklette)
- Add `$config_file` and `$config_contents` parameters to `aptly` class
  to allow changing the location on disk and contents of the config file
  (thanks @mklette and @antonio)
- Allow an `aptly::mirror` to have more than one key (thanks @dw-thomast)
- Use full 40 character key for `repo.aptly.info` as short fingerprints are
  susceptible to collision attacks (thanks @amosshapira)
- Fix type check of `$key` in `aptly::mirror` (thanks @sw0x2A)
- Fix comment in `aptly::mirror` (thanks @zeysh)

2015-04-23 Release 0.3.0
- Add an `aptly::api` class for configuring aptly's API service.
- Add support for specifying repos and mirrors in hieradata.
- Convert Modulefile to metadata.json
- Bugfix: use absolute references to `::aptly` class to prevent a
  dependency cycle.

2014-06-26 Release 0.2.0
- Add `user` param to parent class for the user that `aptly::mirror` and
  `aptly::repo` commands are run as.
- Add `key_server` param to parent class for the key server to use when
  verifying aptly's own repo.
- Add `key_server` param to `aptly::mirror` so that you can specify a
  different hostname or protocol.
- All defaults match the behaviour of previous versions.

2014-05-16 Release 0.1.1
- Transfer to gds-operations and release to Forge.
- No functional changes.

2014-05-15 Release 0.1.0
- Remove support for Ruby 1.8
- Add `package_ensure` param so that you can specify a version
- aptly::repo for creating local repos

2014-03-31 Release 0.0.1
- First release
- Basic install and config
- aptly::mirror for creating mirror entries


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
