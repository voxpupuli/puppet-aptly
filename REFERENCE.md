# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

* [`aptly`](#aptly): aptly is a swiss army knife for Debian repository management
* [`aptly::api`](#aptly--api): Install and configure Aptly's API Service

### Defined types

* [`aptly::mirror`](#aptly--mirror): aptly::mirror

Create a mirror using `aptly mirror create`. It will not update, snapshot,
or publish the mirror for you, because it will take a long time and it
doesn't make sense to schedule these actions frequenly in Puppet.

NB: This will not recreate the mirror if the params change! You will need
to manually `aptly mirror drop <name>` after also dropping all snapshot
and publish references.
* [`aptly::repo`](#aptly--repo): aptly::repo

Create a repository using `aptly create`. It will not snapshot, or update the
repository for you, because it will take a long time and it doesn't make sense
to schedule these actions frequently in Puppet.
* [`aptly::snapshot`](#aptly--snapshot): Create a snapshot using `aptly snapshot`.

### Tasks

* [`mirror_create`](#mirror_create): Create new mirror
* [`mirror_drop`](#mirror_drop): Delete the mirror
* [`mirror_list`](#mirror_list): List mirrors
* [`mirror_update`](#mirror_update): Update the mirror
* [`publish_drop`](#publish_drop): Stop publishing repository
* [`publish_list`](#publish_list): List published repositories
* [`publish_repo`](#publish_repo): Publish the snapshot(s)
* [`publish_snapshot`](#publish_snapshot): Publish the snapshot(s)
* [`publish_switch`](#publish_switch): Update published repository by switching to new snapshot
* [`publish_update`](#publish_update): Update published local repository
* [`repo_add`](#repo_add): Add package to local repository
* [`repo_create`](#repo_create): Create local repository
* [`repo_drop`](#repo_drop): Delete the repo
* [`repo_list`](#repo_list): List repos
* [`repo_remove`](#repo_remove): Remove package from local repository
* [`snapshot_create`](#snapshot_create): Create new snapshot
* [`snapshot_drop`](#snapshot_drop): Delete the snapshot
* [`snapshot_list`](#snapshot_list): List snapshots

## Classes

### <a name="aptly"></a>`aptly`

aptly is a swiss army knife for Debian repository management

#### Parameters

The following parameters are available in the `aptly` class:

* [`package_ensure`](#-aptly--package_ensure)
* [`config_file`](#-aptly--config_file)
* [`config_contents`](#-aptly--config_contents)
* [`config`](#-aptly--config)
* [`repo`](#-aptly--repo)
* [`key_server`](#-aptly--key_server)
* [`user`](#-aptly--user)
* [`aptly_repos`](#-aptly--aptly_repos)
* [`aptly_mirrors`](#-aptly--aptly_mirrors)

##### <a name="-aptly--package_ensure"></a>`package_ensure`

Data type: `String`

Ensure parameter to pass to the package resource.

Default value: `'installed'`

##### <a name="-aptly--config_file"></a>`config_file`

Data type: `Stdlib::Absolutepath`

Absolute path to the configuration file. Defaults to

Default value: `'/etc/aptly.conf'`

##### <a name="-aptly--config_contents"></a>`config_contents`

Data type: `Optional[String]`

Contents of the config file.

Default value: `undef`

##### <a name="-aptly--config"></a>`config`

Data type: `Hash`

Hash of configuration options for `/etc/aptly.conf`. See http://www.aptly.info/#configuration

Default value: `{}`

##### <a name="-aptly--repo"></a>`repo`

Data type: `Boolean`

Whether to configure an apt::source for `repo.aptly.info`. You might want to disable this when you've mirrored that yourself.

Default value: `true`

##### <a name="-aptly--key_server"></a>`key_server`

Data type: `Stdlib::Fqdn`

Key server to use when `$repo` is true.

Default value: `'keyserver.ubuntu.com'`

##### <a name="-aptly--user"></a>`user`

Data type: `String`

The user to use when performing an aptly command

Default value: `'root'`

##### <a name="-aptly--aptly_repos"></a>`aptly_repos`

Data type: `Hash`

Hash of aptly repos which is passed to aptly::repo

Default value: `{}`

##### <a name="-aptly--aptly_mirrors"></a>`aptly_mirrors`

Data type: `Hash`

Hash of aptly mirrors which is passed to aptly::mirror

Default value: `{}`

### <a name="aptly--api"></a>`aptly::api`

Install and configure Aptly's API Service

#### Parameters

The following parameters are available in the `aptly::api` class:

* [`ensure`](#-aptly--api--ensure)
* [`user`](#-aptly--api--user)
* [`group`](#-aptly--api--group)
* [`listen`](#-aptly--api--listen)
* [`log`](#-aptly--api--log)
* [`enable_cli_and_http`](#-aptly--api--enable_cli_and_http)

##### <a name="-aptly--api--ensure"></a>`ensure`

Data type: `Enum['stopped','running']`

Ensure to pass on to service type

Default value: `running`

##### <a name="-aptly--api--user"></a>`user`

Data type: `String[1]`

User to run the service as.

Default value: `'root'`

##### <a name="-aptly--api--group"></a>`group`

Data type: `String[1]`

Group to run the service as.

Default value: `'root'`

##### <a name="-aptly--api--listen"></a>`listen`

Data type: `Pattern['^([0-9.]*:[0-9]+$|unix:)']`

What IP/port to listen on for API requests.

Default value: `':8080'`

##### <a name="-aptly--api--log"></a>`log`

Data type: `Enum['none','log']`

Enable or disable Upstart logging.

Default value: `'none'`

##### <a name="-aptly--api--enable_cli_and_http"></a>`enable_cli_and_http`

Data type: `Boolean`

Enable concurrent use of command line (CLI) and HTTP APIs with the same Aptly root.

Default value: `false`

## Defined types

### <a name="aptly--mirror"></a>`aptly::mirror`

aptly::mirror

Create a mirror using `aptly mirror create`. It will not update, snapshot,
or publish the mirror for you, because it will take a long time and it
doesn't make sense to schedule these actions frequenly in Puppet.

NB: This will not recreate the mirror if the params change! You will need
to manually `aptly mirror drop <name>` after also dropping all snapshot
and publish references.

#### Parameters

The following parameters are available in the `aptly::mirror` defined type:

* [`location`](#-aptly--mirror--location)
* [`key`](#-aptly--mirror--key)
* [`filter`](#-aptly--mirror--filter)
* [`release`](#-aptly--mirror--release)
* [`repos`](#-aptly--mirror--repos)
* [`architectures`](#-aptly--mirror--architectures)
* [`with_sources`](#-aptly--mirror--with_sources)
* [`with_udebs`](#-aptly--mirror--with_udebs)
* [`filter_with_deps`](#-aptly--mirror--filter_with_deps)
* [`environment`](#-aptly--mirror--environment)
* [`keyring`](#-aptly--mirror--keyring)
* [`force_components`](#-aptly--mirror--force_components)

##### <a name="-aptly--mirror--location"></a>`location`

Data type: `String`

URL of the APT repo.

##### <a name="-aptly--mirror--key"></a>`key`

Data type: `Variant[String[1], Hash[String[1],Variant[Array,Integer[1],String[1]]]]`

This can either be a key id or a hash including key options. If using a hash, key => { 'id' => <id> } must be specified

Default value: `{}`

##### <a name="-aptly--mirror--filter"></a>`filter`

Data type: `Optional[String[1]]`

Package query that is applied to packages in the mirror

Default value: `undef`

##### <a name="-aptly--mirror--release"></a>`release`

Data type: `String`

Distribution to mirror for.

Default value: `$facts['os']['distro']['codename']`

##### <a name="-aptly--mirror--repos"></a>`repos`

Data type: `Array`

Components to mirror. If an empty array then aptly will default to mirroring all components.

Default value: `[]`

##### <a name="-aptly--mirror--architectures"></a>`architectures`

Data type: `Array`

Architectures to mirror. If attribute is ommited Aptly will mirror all available architectures.

Default value: `[]`

##### <a name="-aptly--mirror--with_sources"></a>`with_sources`

Data type: `Boolean`

Boolean to control whether Aptly should download source packages in addition to binary packages.

Default value: `false`

##### <a name="-aptly--mirror--with_udebs"></a>`with_udebs`

Data type: `Boolean`

Boolean to control whether Aptly should also download .udeb packages.

Default value: `false`

##### <a name="-aptly--mirror--filter_with_deps"></a>`filter_with_deps`

Data type: `Boolean`

Boolean to control whether when filtering to include dependencies of matching packages as well

Default value: `false`

##### <a name="-aptly--mirror--environment"></a>`environment`

Data type: `Array`

Optional environment variables to pass to the exec. Example: ['http_proxy=http://127.0.0.2:3128']

Default value: `[]`

##### <a name="-aptly--mirror--keyring"></a>`keyring`

Data type: `String`

path to the keyring used by aptly

Default value: `'/etc/apt/trusted.gpg'`

##### <a name="-aptly--mirror--force_components"></a>`force_components`

Data type: `Boolean`

Boolean to control whether Aptly should force download of components.

Default value: `false`

### <a name="aptly--repo"></a>`aptly::repo`

aptly::repo

Create a repository using `aptly create`. It will not snapshot, or update the
repository for you, because it will take a long time and it doesn't make sense
to schedule these actions frequently in Puppet.

#### Parameters

The following parameters are available in the `aptly::repo` defined type:

* [`architectures`](#-aptly--repo--architectures)
* [`comment`](#-aptly--repo--comment)
* [`component`](#-aptly--repo--component)
* [`distribution`](#-aptly--repo--distribution)

##### <a name="-aptly--repo--architectures"></a>`architectures`

Data type: `Array`

Specify the list of supported architectures as an Array. If ommited Aptly assumes the repository.

Default value: `[]`

##### <a name="-aptly--repo--comment"></a>`comment`

Data type: `Optional[String[1]]`

Specifiy a comment to be set for the repository.

Default value: `undef`

##### <a name="-aptly--repo--component"></a>`component`

Data type: `Optional[String[1]]`

Specify which component to put the package in. This option will only works for aptly version >= 0.5.0.

Default value: `undef`

##### <a name="-aptly--repo--distribution"></a>`distribution`

Data type: `Optional[String[1]]`

Specify the default distribution to be used when publishing this repository.

Default value: `undef`

### <a name="aptly--snapshot"></a>`aptly::snapshot`

Create a snapshot using `aptly snapshot`.

#### Parameters

The following parameters are available in the `aptly::snapshot` defined type:

* [`repo`](#-aptly--snapshot--repo)
* [`mirror`](#-aptly--snapshot--mirror)

##### <a name="-aptly--snapshot--repo"></a>`repo`

Data type: `Optional[String[1]]`

Create snapshot from given repo.

Default value: `undef`

##### <a name="-aptly--snapshot--mirror"></a>`mirror`

Data type: `Optional[String[1]]`

Create snapshot from given mirror.

Default value: `undef`

## Tasks

### <a name="mirror_create"></a>`mirror_create`

Create new mirror

**Supports noop?** false

#### Parameters

##### `name`

Data type: `String[1]`

Mirror name

##### `url`

Data type: `Stdlib::HTTPUrl`

Archive URL

##### `distribution`

Data type: `String[1]`

Distribution name

##### `component`

Data type: `Optional[Variant[String[1],Array[String[1]]]]`

An optional component (or list of components) to fetch (or all if not specified)

##### `filter`

Data type: `Optional[String[1]]`

Package query filter that is applied to packages in the mirror

##### `filter_with_deps`

Data type: `Optional[Boolean]`

When filtering, include dependencies of matching packages as well

##### `force_architectures`

Data type: `Optional[Boolean]`

Skip check that requested architectures are listed in Release file

##### `force_components`

Data type: `Optional[Boolean]`

Skip check that requested components are listed in Release file

##### `ignore_signatures`

Data type: `Optional[Boolean]`

Disable verification of Release file signatures

##### `keyring`

Data type: `Optional[Variant[Stdlib::Absolutepath,Array[Stdlib::Absolutepath]]]`

GPG keyring(s) to use when verifying Release file

##### `max_tries`

Data type: `Optional[Integer[0]]`

Max download tries till process fails with download error

##### `with_installer`

Data type: `Optional[Boolean]`

Download additional not packaged installer files

##### `with_sources`

Data type: `Optional[Boolean]`

Download source packages in addition to binary packages

##### `with_udebs`

Data type: `Optional[Boolean]`

Download .udeb packages (Debian installer support)

##### `architectures`

Data type: `Optional[Variant[String[1],Array[String[1]]]]`

List of architectures to consider (or all available if not specified)

##### `config`

Data type: `Optional[Stdlib::Absolutepath]`

Location of configuration file

##### `dep_follow_all_variants`

Data type: `Optional[Boolean]`

When processing dependencies, follow a & b if dependency is 'a|b'

##### `dep_follow_recommends`

Data type: `Optional[Boolean]`

When processing dependencies, follow Recommends

##### `dep_follow_source`

Data type: `Optional[Boolean]`

When processing dependencies, follow from binary to Source packages

##### `dep_follow_suggests`

Data type: `Optional[Boolean]`

When processing dependencies, follow Suggests

### <a name="mirror_drop"></a>`mirror_drop`

Delete the mirror

**Supports noop?** false

#### Parameters

##### `name`

Data type: `String[1]`

Mirror name

##### `force`

Data type: `Optional[Boolean]`

Force mirror deletion even if used by snapshots

##### `config`

Data type: `Optional[Stdlib::Absolutepath]`

Location of configuration file

### <a name="mirror_list"></a>`mirror_list`

List mirrors

**Supports noop?** false

#### Parameters

##### `config`

Data type: `Optional[Stdlib::Absolutepath]`

Location of configuration file

### <a name="mirror_update"></a>`mirror_update`

Update the mirror

**Supports noop?** false

#### Parameters

##### `name`

Data type: `String[1]`

Mirror name

##### `download_limit`

Data type: `Optional[Integer[0]]`

Limit download speed (kbytes/sec)

##### `downloader`

Data type: `Optional[Enum['default','grab']]`

Downloader to use

##### `force`

Data type: `Optional[Boolean]`

Force update mirror even if it is locked by another process

##### `ignore_checksums`

Data type: `Optional[Boolean]`

Ignore checksum mismatches while downloading package files and metadata

##### `ignore_signatures`

Data type: `Optional[Boolean]`

Disable verification of Release file signatures

##### `keyring`

Data type: `Optional[Variant[Stdlib::Absolutepath,Array[Stdlib::Absolutepath]]]`

GPG keyring(s) to use when verifying Release file

##### `max_tries`

Data type: `Optional[Integer[0]]`

Max download tries till process fails with download error

##### `skip_existing_packages`

Data type: `Optional[Boolean]`

Do not check file existence for packages listed in the internal database of the mirror

##### `architectures`

Data type: `Optional[Variant[String[1],Array[String[1]]]]`

List of architectures to consider (or all available if not specified)

##### `config`

Data type: `Optional[Stdlib::Absolutepath]`

Location of configuration file

##### `dep_follow_all_variants`

Data type: `Optional[Boolean]`

When processing dependencies, follow a & b if dependency is 'a|b'

##### `dep_follow_recommends`

Data type: `Optional[Boolean]`

When processing dependencies, follow Recommends

##### `dep_follow_source`

Data type: `Optional[Boolean]`

When processing dependencies, follow from binary to Source packages

##### `dep_follow_suggests`

Data type: `Optional[Boolean]`

When processing dependencies, follow Suggests

### <a name="publish_drop"></a>`publish_drop`

Stop publishing repository

**Supports noop?** false

#### Parameters

##### `distribution`

Data type: `String[1]`

Distribution name of published repository

##### `prefix`

Data type: `Optional[String[1]]`

Publishing prefix (may include endpoint)

##### `force_drop`

Data type: `Optional[Boolean]`

Remove published repository even if some files could not be cleaned up

##### `skip_cleanup`

Data type: `Optional[Boolean]`

Don't remove unreferenced files in prefix/component

##### `config`

Data type: `Optional[Stdlib::Absolutepath]`

Location of configuration file

### <a name="publish_list"></a>`publish_list`

List published repositories

**Supports noop?** false

#### Parameters

##### `config`

Data type: `Optional[Stdlib::Absolutepath]`

Location of configuration file

### <a name="publish_repo"></a>`publish_repo`

Publish the snapshot(s)

**Supports noop?** false

#### Parameters

##### `name`

Data type: `String[1]`

Repository name to publish

##### `prefix`

Data type: `Optional[String[1]]`

Publishing prefix (may include endpoint)

##### `acquire_by_hash`

Data type: `Optional[Boolean]`

Provide index files by hash

##### `batch`

Data type: `Optional[Boolean]`

Run GPG with detached tty

##### `but_automatic_upgrades`

Data type: `Optional[String[1]]`

Overwrite value for ButAutomaticUpgrades field

##### `component`

Data type: `Optional[Variant[String[1],Array[String[1]]]]`

Component name (or list of components) to publish

##### `distribution`

Data type: `Optional[String[1]]`

Distribution name to publish

##### `force_overwrite`

Data type: `Optional[Boolean]`

Overwrite files in package pool in case of mismatch

##### `gpg_key`

Data type: `Optional[String[1]]`

GPG key ID to use when signing the release

##### `keyring`

Data type: `Optional[Variant[Stdlib::Absolutepath,Array[Stdlib::Absolutepath]]]`

GPG keyring(s) to use (instead of default)

##### `label`

Data type: `Optional[String[1]]`

Label to publish

##### `not_automatic`

Data type: `Optional[String[1]]`

Overwrite value for NotAutomatic field

##### `origin`

Data type: `Optional[String[1]]`

Overwrite origin name to publish

##### `passphrase_file`

Data type: `Optional[Stdlib::Absolutepath]`

GPG passphrase-file for the key

##### `secret_keyring`

Data type: `Optional[Stdlib::Absolutepath]`

GPG secret keyring to use (instead of default)

##### `skip_bz2`

Data type: `Optional[Boolean]`

Don't generate bzipped indexes

##### `skip_contents`

Data type: `Optional[Boolean]`

Don't generate Contents indexes

##### `skip_signing`

Data type: `Optional[Boolean]`

Don't sign Release files with GPG

##### `suite`

Data type: `Optional[String[1]]`

Suite to publish (defaults to distribution)

##### `architectures`

Data type: `Optional[Variant[String[1],Array[String[1]]]]`

List of architectures to consider (or all available if not specified)

##### `config`

Data type: `Optional[Stdlib::Absolutepath]`

Location of configuration file

##### `dep_follow_all_variants`

Data type: `Optional[Boolean]`

When processing dependencies, follow a & b if dependency is 'a|b'

##### `dep_follow_recommends`

Data type: `Optional[Boolean]`

When processing dependencies, follow Recommends

##### `dep_follow_source`

Data type: `Optional[Boolean]`

When processing dependencies, follow from binary to Source packages

##### `dep_follow_suggests`

Data type: `Optional[Boolean]`

When processing dependencies, follow Suggests

### <a name="publish_snapshot"></a>`publish_snapshot`

Publish the snapshot(s)

**Supports noop?** false

#### Parameters

##### `name`

Data type: `Variant[String[1],Array[String[1]]]`

Snapshot name(s) to publish

##### `prefix`

Data type: `Optional[String[1]]`

Publishing prefix (may include endpoint)

##### `acquire_by_hash`

Data type: `Optional[Boolean]`

Provide index files by hash

##### `batch`

Data type: `Optional[Boolean]`

Run GPG with detached tty

##### `but_automatic_upgrades`

Data type: `Optional[String[1]]`

Overwrite value for ButAutomaticUpgrades field

##### `component`

Data type: `Optional[Variant[String[1],Array[String[1]]]]`

Component name (or list of components) to publish

##### `distribution`

Data type: `Optional[String[1]]`

Distribution name to publish

##### `force_overwrite`

Data type: `Optional[Boolean]`

Overwrite files in package pool in case of mismatch

##### `gpg_key`

Data type: `Optional[String[1]]`

GPG key ID to use when signing the release

##### `keyring`

Data type: `Optional[Variant[Stdlib::Absolutepath,Array[Stdlib::Absolutepath]]]`

GPG keyring(s) to use (instead of default)

##### `label`

Data type: `Optional[String[1]]`

Label to publish

##### `not_automatic`

Data type: `Optional[String[1]]`

Overwrite value for NotAutomatic field

##### `origin`

Data type: `Optional[String[1]]`

Overwrite origin name to publish

##### `passphrase_file`

Data type: `Optional[Stdlib::Absolutepath]`

GPG passphrase-file for the key

##### `secret_keyring`

Data type: `Optional[Stdlib::Absolutepath]`

GPG secret keyring to use (instead of default)

##### `skip_bz2`

Data type: `Optional[Boolean]`

Don't generate bzipped indexes

##### `skip_contents`

Data type: `Optional[Boolean]`

Don't generate Contents indexes

##### `skip_signing`

Data type: `Optional[Boolean]`

Don't sign Release files with GPG

##### `suite`

Data type: `Optional[String[1]]`

Suite to publish (defaults to distribution)

##### `architectures`

Data type: `Optional[Variant[String[1],Array[String[1]]]]`

List of architectures to consider (or all available if not specified)

##### `config`

Data type: `Optional[Stdlib::Absolutepath]`

Location of configuration file

##### `dep_follow_all_variants`

Data type: `Optional[Boolean]`

When processing dependencies, follow a & b if dependency is 'a|b'

##### `dep_follow_recommends`

Data type: `Optional[Boolean]`

When processing dependencies, follow Recommends

##### `dep_follow_source`

Data type: `Optional[Boolean]`

When processing dependencies, follow from binary to Source packages

##### `dep_follow_suggests`

Data type: `Optional[Boolean]`

When processing dependencies, follow Suggests

### <a name="publish_switch"></a>`publish_switch`

Update published repository by switching to new snapshot

**Supports noop?** false

#### Parameters

##### `distribution`

Data type: `String[1]`

Distribution name of published repository

##### `prefix`

Data type: `Optional[String[1]]`

Publishing prefix (may include endpoint)

##### `snapshot`

Data type: `Variant[String[1],Array[String[1]]]`

Snapshot(s) name to switch to

##### `batch`

Data type: `Optional[Boolean]`

Run GPG with detached tty

##### `component`

Data type: `Optional[Variant[String[1],Array[String[1]]]]`

Component name (or list of components) to publish

##### `force_overwrite`

Data type: `Optional[Boolean]`

Overwrite files in package pool in case of mismatch

##### `gpg_key`

Data type: `Optional[String[1]]`

GPG key ID to use when signing the release

##### `keyring`

Data type: `Optional[Variant[Stdlib::Absolutepath,Array[Stdlib::Absolutepath]]]`

GPG keyring(s) to use (instead of default)

##### `passphrase_file`

Data type: `Optional[Stdlib::Absolutepath]`

GPG passphrase-file for the key

##### `secret_keyring`

Data type: `Optional[Stdlib::Absolutepath]`

GPG secret keyring to use (instead of default)

##### `skip_bz2`

Data type: `Optional[Boolean]`

Don't generate bzipped indexes

##### `skip_cleanup`

Data type: `Optional[Boolean]`

Don't remove unreferenced files in prefix/component

##### `skip_contents`

Data type: `Optional[Boolean]`

Don't generate Contents indexes

##### `skip_signing`

Data type: `Optional[Boolean]`

Don't sign Release files with GPG

##### `architectures`

Data type: `Optional[Variant[String[1],Array[String[1]]]]`

List of architectures to consider (or all available if not specified)

##### `config`

Data type: `Optional[Stdlib::Absolutepath]`

Location of configuration file

##### `dep_follow_all_variants`

Data type: `Optional[Boolean]`

When processing dependencies, follow a & b if dependency is 'a|b'

##### `dep_follow_recommends`

Data type: `Optional[Boolean]`

When processing dependencies, follow Recommends

##### `dep_follow_source`

Data type: `Optional[Boolean]`

When processing dependencies, follow from binary to Source packages

##### `dep_follow_suggests`

Data type: `Optional[Boolean]`

When processing dependencies, follow Suggests

### <a name="publish_update"></a>`publish_update`

Update published local repository

**Supports noop?** false

#### Parameters

##### `distribution`

Data type: `String[1]`

Distribution name of published repository

##### `prefix`

Data type: `Optional[String[1]]`

Publishing prefix (may include endpoint)

##### `batch`

Data type: `Optional[Boolean]`

Run GPG with detached tty

##### `force_overwrite`

Data type: `Optional[Boolean]`

Overwrite files in package pool in case of mismatch

##### `gpg_key`

Data type: `Optional[String[1]]`

GPG key ID to use when signing the release

##### `keyring`

Data type: `Optional[Variant[Stdlib::Absolutepath,Array[Stdlib::Absolutepath]]]`

GPG keyring(s) to use (instead of default)

##### `passphrase_file`

Data type: `Optional[Stdlib::Absolutepath]`

GPG passphrase-file for the key

##### `secret_keyring`

Data type: `Optional[Stdlib::Absolutepath]`

GPG secret keyring to use (instead of default)

##### `skip_bz2`

Data type: `Optional[Boolean]`

Don't generate bzipped indexes

##### `skip_cleanup`

Data type: `Optional[Boolean]`

Don't remove unreferenced files in prefix/component

##### `skip_contents`

Data type: `Optional[Boolean]`

Don't generate Contents indexes

##### `skip_signing`

Data type: `Optional[Boolean]`

Don't sign Release files with GPG

##### `architectures`

Data type: `Optional[Variant[String[1],Array[String[1]]]]`

List of architectures to consider (or all available if not specified)

##### `config`

Data type: `Optional[Stdlib::Absolutepath]`

Location of configuration file

##### `dep_follow_all_variants`

Data type: `Optional[Boolean]`

When processing dependencies, follow a & b if dependency is 'a|b'

##### `dep_follow_recommends`

Data type: `Optional[Boolean]`

When processing dependencies, follow Recommends

##### `dep_follow_source`

Data type: `Optional[Boolean]`

When processing dependencies, follow from binary to Source packages

##### `dep_follow_suggests`

Data type: `Optional[Boolean]`

When processing dependencies, follow Suggests

### <a name="repo_add"></a>`repo_add`

Add package to local repository

**Supports noop?** false

#### Parameters

##### `name`

Data type: `String[1]`

Repository name

##### `package`

Data type: `Optional[String[1]]`

Package name to add (mutually exclusive with directory)

##### `directory`

Data type: `Optional[String[1]]`

Directory to add packages from (mutually exclusive with package)

##### `force_replace`

Data type: `Optional[Boolean]`

When adding package that conflicts with existing package, remove existing package

##### `remove_files`

Data type: `Optional[Boolean]`

Remove files that have been imported successfully into repository

##### `config`

Data type: `Optional[Stdlib::Absolutepath]`

Location of configuration file

### <a name="repo_create"></a>`repo_create`

Create local repository

**Supports noop?** false

#### Parameters

##### `name`

Data type: `String[1]`

Repository name

##### `snapshot`

Data type: `Optional[String[1]]`

If specified, create the repository from the snapshot

##### `comment`

Data type: `Optional[String[1]]`

Any text that would be used to described local repository

##### `component`

Data type: `Optional[String[1]]`

Default component when publishing

##### `distribution`

Data type: `Optional[String[1]]`

Default distribution when publishing

##### `uploaders_file`

Data type: `Optional[Stdlib::Absolutepath]`

Uploaders.json to be used when including .changes into this repository

##### `architectures`

Data type: `Optional[Variant[String[1],Array[String[1]]]]`

List of architectures to consider (or all available if not specified)

##### `config`

Data type: `Optional[Stdlib::Absolutepath]`

Location of configuration file

##### `dep_follow_all_variants`

Data type: `Optional[Boolean]`

When processing dependencies, follow a & b if dependency is 'a|b'

##### `dep_follow_recommends`

Data type: `Optional[Boolean]`

When processing dependencies, follow Recommends

##### `dep_follow_source`

Data type: `Optional[Boolean]`

When processing dependencies, follow from binary to Source packages

##### `dep_follow_suggests`

Data type: `Optional[Boolean]`

When processing dependencies, follow Suggests

### <a name="repo_drop"></a>`repo_drop`

Delete the repo

**Supports noop?** false

#### Parameters

##### `name`

Data type: `String[1]`

Repository name

##### `force`

Data type: `Optional[Boolean]`

Force repo deletion even if used by snapshots

##### `config`

Data type: `Optional[Stdlib::Absolutepath]`

Location of configuration file

### <a name="repo_list"></a>`repo_list`

List repos

**Supports noop?** false

#### Parameters

##### `config`

Data type: `Optional[Stdlib::Absolutepath]`

Location of configuration file

### <a name="repo_remove"></a>`repo_remove`

Remove package from local repository

**Supports noop?** false

#### Parameters

##### `name`

Data type: `String[1]`

Repository name

##### `package_query`

Data type: `Optional[String[1],Array[String[1]]`

Package query (or list of queries)

##### `config`

Data type: `Optional[Stdlib::Absolutepath]`

Location of configuration file

### <a name="snapshot_create"></a>`snapshot_create`

Create new snapshot

**Supports noop?** false

#### Parameters

##### `name`

Data type: `String[1]`

Snapshot name

##### `from`

Data type: `Enum['mirror','repo','empty']`

Snapshot source (mirror, repo, empty)

##### `mirror`

Data type: `Optional[String[1]]`

When snapshot source is mirror, this defines name of the mirror

##### `repo`

Data type: `Optional[String[1]]`

When snapshot source is repo, this defines name of the repo

##### `architectures`

Data type: `Optional[Variant[String[1],Array[String[1]]]]`

List of architectures to consider (or all available if not specified)

##### `config`

Data type: `Optional[Stdlib::Absolutepath]`

Location of configuration file

##### `dep_follow_all_variants`

Data type: `Optional[Boolean]`

When processing dependencies, follow a & b if dependency is 'a|b'

##### `dep_follow_recommends`

Data type: `Optional[Boolean]`

When processing dependencies, follow Recommends

##### `dep_follow_source`

Data type: `Optional[Boolean]`

When processing dependencies, follow from binary to Source packages

##### `dep_follow_suggests`

Data type: `Optional[Boolean]`

When processing dependencies, follow Suggests

### <a name="snapshot_drop"></a>`snapshot_drop`

Delete the snapshot

**Supports noop?** false

#### Parameters

##### `name`

Data type: `String[1]`

Snapshot name

##### `force`

Data type: `Optional[Boolean]`

Remove snapshot even if it was used as source for other snapshots

##### `config`

Data type: `Optional[Stdlib::Absolutepath]`

Location of configuration file

### <a name="snapshot_list"></a>`snapshot_list`

List snapshots

**Supports noop?** false

#### Parameters

##### `config`

Data type: `Optional[Stdlib::Absolutepath]`

Location of configuration file

