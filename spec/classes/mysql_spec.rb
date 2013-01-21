require 'spec_helper'

describe 'mysql' do
  let(:facts) do
    { :boxen_home => '/opt/boxen' }
  end
  it { should contain_package('boxen/brews/mysql') }
  it { should include_class('mysql::config') }
  it { should contain_service('dev.mysql').with(:ensure => 'running') }
  it { should contain_exec('init-mysql-db') }
end
