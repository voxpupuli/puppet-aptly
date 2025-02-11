# frozen_string_literal: true

require 'spec_helper'

describe 'aptly::mirror' do
  let(:title) { 'example' }

  on_supported_os.each do |os, os_facts|
    context "on #{os} with Facter #{os_facts[:facterversion]} and Puppet #{os_facts[:puppetversion]}" do
      let(:facts) { os_facts }

      describe 'param defaults and mandatory' do
        let(:params) do
          {
            location: 'http://repo.example.com',
            key: {
              id: 'ABC123',
              server: 'keyserver.ubuntu.com'
            },
            release: 'precise'
          }
        end

        it do
          is_expected.to contain_exec('aptly_mirror_gpg-example').with(
            command: %r{ --keyserver 'keyserver.ubuntu.com' --recv-keys 'ABC123'$},
            unless: %r{^echo 'ABC123' |},
            user: 'root'
          )
        end

        it do
          is_expected.to contain_exec('aptly_mirror_create-example').with(
            command: %r{aptly -config /etc/aptly.conf mirror create *-with-sources=false -with-udebs=false example http://repo\.example\.com precise$},
            unless: %r{aptly -config /etc/aptly.conf mirror show example >/dev/null$},
            user: 'root',
            require: [
              'Package[aptly]',
              'File[/etc/aptly.conf]',
              'Exec[aptly_mirror_gpg-example]'
            ]
          )
        end

        context 'two repos with same key' do
          let(:params) do
            {
              location: 'http://lucid.example.com',
              key: {
                id: 'ABC123',
                server: 'keyserver.ubuntu.com'
              },
              release: 'precise'
            }
          end

          it do
            is_expected.to contain_exec('aptly_mirror_gpg-example').with(
              command: %r{ --keyserver 'keyserver.ubuntu.com' --recv-keys 'ABC123'$},
              unless: %r{^echo 'ABC123' |},
              user: 'root'
            )
          end

          it do
            is_expected.to contain_exec('aptly_mirror_create-example').with(
              command: %r{aptly -config /etc/aptly.conf mirror create *-with-sources=false -with-udebs=false example http://lucid.example.com precise$},
              unless: %r{aptly -config /etc/aptly.conf mirror show example >/dev/null$},
              user: 'root',
              require: [
                'Package[aptly]',
                'File[/etc/aptly.conf]',
                'Exec[aptly_mirror_gpg-example]'
              ]
            )
          end
        end
      end

      describe '#user' do
        context 'with custom user' do
          let(:pre_condition) do
            <<-PUPPET
            class { 'aptly':
              user => 'custom_user',
            }
            PUPPET
          end

          let(:params) do
            {
              location: 'http://repo.example.com',
              key: {
                id: 'ABC123',
                server: 'keyserver.ubuntu.com'
              },
              release: 'precise'
            }
          end

          it do
            is_expected.to contain_exec('aptly_mirror_gpg-example').with(
              command: %r{ --keyserver 'keyserver.ubuntu.com' --recv-keys 'ABC123'$},
              unless: %r{^echo 'ABC123' |},
              user: 'custom_user'
            )
          end

          it do
            is_expected.to contain_exec('aptly_mirror_create-example').with(
              command: %r{aptly -config /etc/aptly.conf mirror create *-with-sources=false -with-udebs=false example http://repo\.example\.com precise$},
              unless: %r{aptly -config /etc/aptly.conf mirror show example >/dev/null$},
              user: 'custom_user',
              require: [
                'Package[aptly]',
                'File[/etc/aptly.conf]',
                'Exec[aptly_mirror_gpg-example]'
              ]
            )
          end
        end
      end

      describe '#keyserver' do
        context 'with custom keyserver' do
          let(:params) do
            {
              location: 'http://repo.example.com',
              key: {
                id: 'ABC123',
                server: 'keyserver.ubuntu.com'
              }
            }
          end

          it do
            is_expected.to contain_exec('aptly_mirror_gpg-example').with(
              command: %r{ --keyserver 'keyserver.ubuntu.com' --recv-keys 'ABC123'$},
              unless: %r{^echo 'ABC123' |},
              user: 'root'
            )
          end
        end
      end

      describe '#environment' do
        context 'defaults to empty array' do
          let(:params) do
            {
              location: 'http://repo.example.com',
              key: {
                id: 'ABC123',
                server: 'keyserver.ubuntu.com'
              }
            }
          end

          it { is_expected.to contain_exec('aptly_mirror_create-example').with(environment: []) }
        end

        context 'with FOO set to bar' do
          let(:params) do
            {
              location: 'http://repo.example.com',
              key: {
                id: 'ABC123',
                server: 'keyserver.ubuntu.com'
              },
              environment: ['FOO=bar']
            }
          end

          it { is_expected.to contain_exec('aptly_mirror_create-example').with(environment: ['FOO=bar']) }
        end
      end

      describe '#key' do
        context 'single item not in an array' do
          let(:params) do
            {
              location: 'http://repo.example.com',
              key: {
                id: 'ABC123',
                server: 'keyserver.ubuntu.com'
              }
            }
          end

          it do
            is_expected.to contain_exec('aptly_mirror_gpg-example').with(
              command: %r{ --keyserver 'keyserver.ubuntu.com' --recv-keys 'ABC123'$},
              unless: %r{^echo 'ABC123' |}
            )
          end
        end

        context 'single item in an array' do
          let(:params) do
            {
              location: 'http://repo.example.com',
              key: {
                id: %w[ABC123],
                server: 'keyserver.ubuntu.com'
              }
            }
          end

          it do
            is_expected.to contain_exec('aptly_mirror_gpg-example').with(
              command: %r{ --keyserver 'keyserver.ubuntu.com' --recv-keys 'ABC123'$},
              unless: %r{^echo 'ABC123' |}
            )
          end
        end

        context 'multiple items' do
          let(:params) do
            {
              location: 'http://repo.example.com',
              key: {
                id: %w[ABC123 DEF456 GHI789],
                server: 'keyserver.ubuntu.com'
              }
            }
          end

          it do
            is_expected.to contain_exec('aptly_mirror_gpg-example').with(
              command: %r{ --keyserver 'keyserver.ubuntu.com' --recv-keys 'ABC123' 'DEF456' 'GHI789'$},
              unless: %r{^echo 'ABC123' 'DEF456' 'GHI789' |}
            )
          end
        end

        context 'no key passed' do
          let(:params) do
            {
              location: 'http://repo.example.com'
            }
          end

          it { is_expected.not_to contain_exec('aptly_mirror_gpg-example') }
        end
      end

      describe '#repos' do
        context 'single item' do
          let(:params) do
            {
              location: 'http://repo.example.com',
              key: {
                id: 'ABC123',
                server: 'keyserver.ubuntu.com'
              },
              repos: ['main'],
              release: 'precise'
            }
          end

          it do
            is_expected.to contain_exec('aptly_mirror_create-example').with_command(
              %r{aptly -config /etc/aptly.conf mirror create *-with-sources=false -with-udebs=false example http://repo\.example\.com precise main}
            )
          end
        end

        context 'multiple items' do
          let(:params) do
            {
              location: 'http://repo.example.com',
              key: {
                id: 'ABC123',
                server: 'keyserver.ubuntu.com'
              },
              repos: %w[main contrib non-free],
              release: 'precise'
            }
          end

          it do
            is_expected.to contain_exec('aptly_mirror_create-example').with_command(
              %r{aptly -config /etc/aptly.conf mirror create  -with-sources=false -with-udebs=false example http://repo.example.com precise main contrib non-free}
            )
          end
        end
      end

      describe '#architectures' do
        context 'single item' do
          let(:params) do
            {
              location: 'http://repo.example.com',
              key: {
                id: 'ABC123',
                server: 'keyserver.ubuntu.com'
              },
              architectures: ['amd64'],
              release: 'precise'
            }
          end

          it do
            is_expected.to contain_exec('aptly_mirror_create-example').with_command(
              %r{aptly -config /etc/aptly.conf mirror create -architectures='amd64' -with-sources=false -with-udebs=false example http://repo.example.com precise}
            )
          end
        end

        context 'multiple items' do
          let(:params) do
            {
              location: 'http://repo.example.com',
              key: {
                id: 'ABC123',
                server: 'keyserver.ubuntu.com'
              },
              architectures: %w[i386 amd64 armhf],
              release: 'precise'
            }
          end

          it do
            is_expected.to contain_exec('aptly_mirror_create-example').with_command(
              %r{/usr/bin/aptly -config /etc/aptly.conf mirror create -architectures='i386,amd64,armhf' -with-sources=false -with-udebs=false example http://repo.example.com precise}
            )
          end
        end
      end

      describe '#with_sources' do
        context 'with boolean true' do
          let(:params) do
            {
              location: 'http://repo.example.com',
              key: {
                id: 'ABC123',
                server: 'keyserver.ubuntu.com'
              },
              with_sources: true,
              release: 'precise'
            }
          end

          it do
            is_expected.to contain_exec('aptly_mirror_create-example').with_command(
              %r{aptly -config /etc/aptly.conf mirror create  -with-sources=true -with-udebs=false example http://repo.example.com precise}
            )
          end
        end
      end

      describe '#with_udebs' do
        context 'with boolean true' do
          let(:params) do
            {
              location: 'http://repo.example.com',
              key: {
                id: 'ABC123',
                server: 'keyserver.ubuntu.com'
              },
              with_udebs: true,
              release: 'precise'
            }
          end

          it do
            is_expected.to contain_exec('aptly_mirror_create-example').with_command(
              %r{aptly -config /etc/aptly.conf mirror create  -with-sources=false -with-udebs=true example http://repo.example.com precise}
            )
          end
        end
      end

      describe '#filter_with_deps' do
        context 'with boolean true' do
          let(:params) do
            {
              location: 'http://repo.example.com',
              key: {
                id: 'ABC123',
                server: 'keyserver.ubuntu.com'
              },
              filter_with_deps: true,
              release: 'precise'
            }
          end

          it do
            is_expected.to contain_exec('aptly_mirror_create-example').with_command(
              %r{/usr/bin/aptly -config /etc/aptly.conf mirror create  -with-sources=false -with-udebs=false -filter-with-deps example http://repo.example.com precise}
            )
          end
        end
      end

      describe '#filter' do
        context 'with filter' do
          let(:params) do
            {
              location: 'http://repo.example.com',
              key: {
                id: 'ABC123',
                server: 'keyserver.ubuntu.com'
              },
              filter: 'this is a string',
              release: 'precise'
            }
          end

          it do
            is_expected.to contain_exec('aptly_mirror_create-example').with_command(
              %r{/usr/bin/aptly -config /etc/aptly.conf mirror create  -with-sources=false -with-udebs=false -filter="this is a string" example http://repo.example.com precise}
            )
          end
        end
      end

      describe '#force_components' do
        context 'with boolean true' do
          let(:params) do
            {
              location: 'http://repo.example.com',
              key: {
                id: 'ABC123',
                server: 'keyserver.ubuntu.com'
              },
              force_components: true,
              release: 'precise'
            }
          end

          it {
            is_expected.to contain_exec('aptly_mirror_create-example').with_command(
              %r{/usr/bin/aptly -config /etc/aptly.conf mirror create  -with-sources=false -with-udebs=false -force-components example http://repo.example.com precise}
            )
          }
        end
      end
    end
  end
end
