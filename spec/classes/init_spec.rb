# frozen_string_literal: true

require 'spec_helper'

describe 'aptly' do
  on_supported_os.each do |os, facts|
    context "on #{os} with Facter #{facts[:facterversion]} and Puppet #{facts[:puppetversion]}" do
      let(:facts) { facts }

      context 'param defaults' do
        let(:params) { {} }

        it { is_expected.to contain_apt__source('aptly') }
        it { is_expected.to contain_package('aptly').that_requires('Class[Apt::Update]') }
        it { is_expected.to contain_file('/etc/aptly.conf').with_content("{}\n") }
      end

      describe '#package_ensure' do
        context 'present (default)' do
          let(:params) { {} }

          it { is_expected.to contain_package('aptly').with_ensure('installed') }
        end

        context '1.2.3' do
          let(:params) { { package_ensure: '1.2.3' } }

          it { is_expected.to contain_package('aptly').with_ensure('1.2.3') }
        end
      end

      describe '#config_file' do
        context 'not an absolute path' do
          let(:params) { { config_file: 'relativepath/aptly.conf' } }

          it { is_expected.to raise_error(Puppet::PreformattedError, %r{parameter 'config_file' expects a .*Stdlib::{Absolute|Windows|Unix}path}) }
        end

        context 'custom config path' do
          let(:params) { { config_file: '/etc/aptly/aptly.conf' } }

          it { is_expected.to contain_file('/etc/aptly/aptly.conf') }
        end
      end

      describe '#config' do
        context 'not a hash' do
          let(:params) { { config: 'this is a string' } }

          it { is_expected.to raise_error(Puppet::PreformattedError, %r{parameter 'config' expects a Hash value, got String}) }
        end

        context 'rootDir and architectures' do
          let(:params) do
            {
              config: {
                'rootDir' => '/srv/aptly',
                'architectures' => %w[i386 amd64]
              }
            }
          end

          it { is_expected.to contain_file('/etc/aptly.conf').with_content(%r{architectures}).with_content(%r{i386}).with_content(%r{rootDir}).with_content(%r{/srv/aptly}) }
        end
      end

      describe '#config_contents' do
        context 'not a string' do
          let(:params) { { config_contents: { 'a' => 1 } } }

          it { is_expected.to raise_error(Puppet::PreformattedError, %r{parameter 'config_contents' expects a value of type Undef or String, got Struct}) }
        end

        context 'rootDir and architectures' do
          let(:params) { { config_contents: '{"rootDir":"/srv/aptly", "architectures":["i386", "amd64"]}' } }

          it { is_expected.to contain_file('/etc/aptly.conf').with_content(params[:config_contents]) }
        end
      end

      describe '#repo' do
        context 'not a bool' do
          let(:params) { { repo: 'this is a string' } }

          it { is_expected.to raise_error(Puppet::PreformattedError, %r{parameter 'repo' expects a Boolean value, got String}) }
        end

        context 'false' do
          let(:params) { { repo: false } }

          it { is_expected.not_to contain_apt__source('aptly') }
        end
      end
    end
  end
end
