# frozen_string_literal: true

require 'spec_helper'

describe 'aptly::api' do
  on_supported_os.each do |os, facts|
    context "on #{os} with Facter #{facts[:facterversion]} and Puppet #{facts[:puppetversion]}" do
      let(:facts) { facts }

      context 'param defaults' do
        it do
          is_expected.to contain_file('aptly-systemd').
            with_path('/etc/systemd/system/aptly-api.service').
            without_content(%r{^\s*author }).
            with_content(%r{^User=root$}).
            with_content(%r{^Group=root$}).
            with_content(%r{^ExecStart=/usr/bin/aptly api serve -listen=:8080$}).
            that_notifies('Service[aptly-api]')
        end

        it do
          is_expected.to contain_service('aptly-api').
            with_ensure('running').
            with_enable(true)
        end
      end

      describe 'ensure' do
        context 'present (default)' do
          it { is_expected.to contain_service('aptly-api').with_ensure('running') }
        end

        context 'stopped' do
          let(:params) { { ensure: 'stopped' } }

          it { is_expected.to contain_service('aptly-api').with_ensure('stopped') }
        end
      end

      describe 'user' do
        context 'custom' do
          let(:params) { { user: 'yolo' } }

          it { is_expected.to contain_file('aptly-systemd').with_content(%r{^User=yolo$}) }
        end
      end

      describe 'group' do
        context 'custom' do
          let(:params) { { group: 'yolo' } }

          it { is_expected.to contain_file('aptly-systemd').with_content(%r{^Group=yolo$}) }
        end
      end

      describe 'listen' do
        context 'custom' do
          let(:params) { { listen: '127.0.0.1:9090' } }

          it { is_expected.to contain_file('aptly-systemd').with_content(%r{^ExecStart=/usr/bin/aptly api serve -listen=127.0.0.1:9090$}) }
        end
      end

      describe 'enable_cli_and_http' do
        context 'false (default)' do
          it { is_expected.to contain_file('aptly-systemd').without_content(%r{ -no-lock}) }
        end

        context 'true' do
          let(:params) { { enable_cli_and_http: true } }

          it { is_expected.to contain_file('aptly-systemd').with_content(%r{ -no-lock}) }
        end
      end
    end
  end
end
