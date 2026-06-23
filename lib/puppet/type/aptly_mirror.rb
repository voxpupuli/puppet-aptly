# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'aptly_mirror',
  docs: <<~EOS,
    @summary Manage Aptly mirrors

    This resource type provides Puppet with the capabilities to manage Aptly
    mirror by calling the `aptly` CLI.
  EOS
  features: ['supports_noop'],
  attributes: {
    name: {
      desc: 'Mirror name',
      type: 'String[1]',
      behaviour: :namevar,
    },
    ensure: {
      desc: 'Whether the mirror should be present or absent',
      type: "Enum['present','absent']",
      default: 'present',
    },
    url: {
      desc: 'Archive URL',
      type: 'Stdlib::HTTPUrl',
    },
    distribution: {
      desc: 'Distribution name',
      type: 'String[1]',
    },
    component: {
      desc: 'An optional component (or list of components) to fetch (or all if not specified)',
      type: 'Optional[Variant[String[1],Array[String[1]]]]',
    },
    architectures: {
      desc: 'List of architectures to consider (or all available if not specified)',
      type: 'Optional[Variant[String[1],Array[String[1]]]]',
    },
    config: {
      desc: 'Configuration file location',
      type: 'Optional[Stdlib::Absolutepath]',
      behaviour: :parameter,
    },
    dep_follow_all_variants: {
      desc: 'When processing dependencies, follow a & b if dependency is a|b',
      type: 'Optional[Boolean]',
      behaviour: :parameter,
    },
    dep_follow_recommends: {
      desc: 'When processing dependencies, follow Recommends',
      type: 'Optional[Boolean]',
      behaviour: :parameter,
    },
    dep_follow_source: {
      desc: 'When processing dependencies, follow from binary to Source packages',
      type: 'Optional[Boolean]',
      behaviour: :parameter,
    },
    dep_follow_suggests: {
      desc: 'When processing dependencies, follow Suggests',
      type: 'Optional[Boolean]',
      behaviour: :parameter,
    },
    filter: {
      desc: 'Package query filter that is applied to packages in the mirror',
      type: 'Optional[String]',
    },
    filter_with_deps: {
      desc: 'When filtering, include dependencies of matching packages as well',
      type: 'Optional[Boolean]',
    },
    force_architectures: {
      desc: 'Skip check that requested architectures are listed in Release file',
      type: 'Optional[Boolean]',
    },
    force_components: {
      desc: 'Skip check that requested architectures are listed in Release file',
      type: 'Optional[Boolean]',
    },
    ignore_signatures: {
      desc: 'Disable verification of Release file signatures',
      type: 'Optional[Boolean]',
      behaviour: :parameter,
    },
    max_tries: {
      desc: 'Max download tries till process fails with download error',
      type: 'Optional[Integer[0]]',
      behaviour: :parameter,
    },
    with_installer: {
      desc: 'Download additional not packaged installer files',
      type: 'Optional[Boolean]',
    },
    with_sources: {
      desc: 'Download source packages in addition to binary packages',
      type: 'Optional[Boolean]',
    },
    with_udebs: {
      desc: 'Download .udeb packages (Debian installer support)',
      type: 'Optional[Boolean]',
    },
    aptly_command: {
      desc: 'Path to aptly binary',
      type: 'Optional[String[1]]',
      behaviour: :parameter,
    },
    aptly_environment: {
      desc: 'Environment variables to set when executing aptly binary',
      type: 'Hash[String[1], ScalarData]',
      behaviour: :parameter,
    },
  },
)
