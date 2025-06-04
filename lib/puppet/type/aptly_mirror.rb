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
  }
)
