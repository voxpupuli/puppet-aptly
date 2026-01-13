# frozen_string_literal: true

require 'spec_helper'

describe 'aptly::serve' do
  on_supported_os.each do |os, facts|
    context "on #{os} with Facter #{facts[:facterversion]} and Puppet #{facts[:puppetversion]}" do
      let(:facts) { facts }

      context 'param defaults' do
        it { is_expected.to contain_systemd__unit_file('aptly-serve.service') }

        it do
          is_expected.to contain_file('/etc/systemd/system/aptly-serve.service').
            without_content(%r{^\s*author }).
            with_content(%r{^User=root$}).
            with_content(%r{^Group=root$}).
            with_content(%r{^ExecStart=/usr/bin/aptly serve -listen=:8080 -config=/etc/aptly\.conf$}).
            that_notifies('Service[aptly-serve.service]')
        end

        it do
          is_expected.to contain_service('aptly-serve.service').
            with_ensure(true).
            with_enable(true)
        end
      end

      describe 'ensure' do
        context 'present (default)' do
          it { is_expected.to contain_service('aptly-serve.service').with_ensure(true) }
        end

        context 'stopped' do
          let(:params) { { ensure: 'stopped' } }

          it { is_expected.to contain_service('aptly-serve.service').with_ensure(false) }
          it { is_expected.to contain_service('aptly-serve.service').with_enable(false) }
        end
      end

      describe 'user' do
        context 'custom' do
          let(:params) { { user: 'yolo' } }

          it { is_expected.to contain_file('/etc/systemd/system/aptly-serve.service').with_content(%r{^User=yolo$}) }
        end
      end

      describe 'group' do
        context 'custom' do
          let(:params) { { group: 'yolo' } }

          it { is_expected.to contain_file('/etc/systemd/system/aptly-serve.service').with_content(%r{^Group=yolo$}) }
        end
      end

      describe 'listen' do
        context 'custom' do
          let(:params) { { listen: '127.0.0.1:9090' } }

          it { is_expected.to contain_file('/etc/systemd/system/aptly-serve.service').with_content(%r{^ExecStart=/usr/bin/aptly serve -listen=127\.0\.0\.1:9090 -config=/etc/aptly\.conf$}) }
        end
      end

      describe 'config_file' do
        context 'custom' do
          let(:params) { { config_file: '/etc/aptly/aptly.conf' } }

          it { is_expected.to contain_file('/etc/systemd/system/aptly-serve.service').with_content(%r{^ExecStart=/usr/bin/aptly serve -listen=:8080 -config=/etc/aptly/aptly\.conf$}) }
        end
      end
    end
  end
end
