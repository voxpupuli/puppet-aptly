# frozen_string_literal: true

require 'spec_helper'

describe 'aptly::repo' do
  let(:title) { 'example' }

  on_supported_os.each do |os, facts|
    context "on #{os} with Facter #{facts[:facterversion]} and Puppet #{facts[:puppetversion]}" do
      let(:facts) { facts }

      describe 'param defaults' do
        it do
          is_expected.to contain_exec('aptly_repo_create-example').with(
            command: %r{aptly -config /etc/aptly.conf repo create *example},
            unless: %r{aptly -config /etc/aptly.conf repo show example >/dev/null},
            user: 'root',
            require: ['Package[aptly]', 'File[/etc/aptly.conf]']
          )
        end
      end

      describe 'user defined component' do
        let(:params) { { component: 'third-party' } }

        it do
          is_expected.to contain_exec('aptly_repo_create-example').with(
            command: %r{aptly -config /etc/aptly.conf repo create *-component="third-party" *example},
            unless: %r{aptly -config /etc/aptly.conf repo show example >/dev/null},
            user: 'root',
            require: ['Package[aptly]', 'File[/etc/aptly.conf]']
          )
        end

        context 'custom user' do
          let(:pre_condition) do
            <<-PUPPET
            class { 'aptly':
              user => 'custom_user',
            }
            PUPPET
          end

          let(:params) { { component: 'third-party' } }

          it do
            is_expected.to contain_exec('aptly_repo_create-example').with(
              command: %r{aptly -config /etc/aptly.conf repo create *-component="third-party" *example},
              unless: %r{aptly -config /etc/aptly.conf repo show example >/dev/null},
              user: 'custom_user',
              require: ['Package[aptly]', 'File[/etc/aptly.conf]']
            )
          end
        end
      end

      describe 'user defined architectures' do
        context 'passing valid values' do
          let(:params) { { architectures: %w[i386 amd64] } }

          it do
            is_expected.to contain_exec('aptly_repo_create-example').with(
              command: %r{aptly -config /etc/aptly.conf repo create *-architectures="i386,amd64" *example},
              unless: %r{aptly -config /etc/aptly.conf repo show example >/dev/null},
              user: 'root',
              require: ['Package[aptly]', 'File[/etc/aptly.conf]']
            )
          end
        end

        context 'passing invalid values' do
          let(:params) { { architectures: 'amd64' } }

          it { is_expected.to raise_error(Puppet::PreformattedError, %r{parameter 'architectures' expects an Array value, got String}) }
        end
      end

      describe 'user defined comment' do
        let(:params) { { comment: 'example comment' } }

        it do
          is_expected.to contain_exec('aptly_repo_create-example').with(
            command: %r{aptly -config /etc/aptly.conf repo create *-comment="example comment" *example},
            unless: %r{aptly -config /etc/aptly.conf repo show example >/dev/null},
            user: 'root',
            require: ['Package[aptly]', 'File[/etc/aptly.conf]']
          )
        end
      end

      describe 'user defined distribution' do
        let(:params) { { distribution: 'example_distribution' } }

        it do
          is_expected.to contain_exec('aptly_repo_create-example').with(
            command: %r{aptly -config /etc/aptly.conf repo create *-distribution="example_distribution" *example},
            unless: %r{aptly -config /etc/aptly.conf repo show example >/dev/null},
            user: 'root',
            require: ['Package[aptly]', 'File[/etc/aptly.conf]']
          )
        end
      end
    end
  end
end
