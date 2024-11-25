# frozen_string_literal: true

require 'spec_helper'

describe 'aptly::snapshot' do
  let(:title) { 'example' }

  on_supported_os.each do |os, facts|
    context "on #{os} with Facter #{facts[:facterversion]} and Puppet #{facts[:puppetversion]}" do
      let(:facts) { facts }

      describe 'param defaults' do
        it do
          is_expected.to contain_exec('aptly_snapshot_create-example').with(
            command: %r{aptly -config /etc/aptly.conf snapshot create example empty},
            unless: %r{aptly -config /etc/aptly.conf snapshot show example >/dev/null},
            user: 'root',
            require: 'Class[Aptly]'
          )
        end
      end

      describe 'user defined params' do
        context 'passing both params' do
          let(:params) { { repo: 'example_repo', mirror: 'example_mirror' } }

          it { is_expected.to raise_error(Puppet::Error, %r{mutually exclusive}) }
        end

        context 'passing repo param' do
          let(:params) { { repo: 'example_repo' } }

          it do
            is_expected.to contain_exec('aptly_snapshot_create-example').with(
              command: %r{aptly -config /etc/aptly.conf snapshot create example from repo example_repo},
              unless: %r{aptly -config /etc/aptly.conf snapshot show example >/dev/null},
              user: 'root',
              require: 'Class[Aptly]'
            )
          end
        end

        context 'passing mirror param' do
          let(:params) { { mirror: 'example_mirror' } }

          it do
            is_expected.to contain_exec('aptly_snapshot_create-example').with(
              command: %r{aptly -config /etc/aptly.conf snapshot create example from mirror example_mirror},
              unless: %r{aptly -config /etc/aptly.conf snapshot show example >/dev/null},
              user: 'root',
              require: 'Class[Aptly]'
            )
          end
        end
      end
    end
  end
end
