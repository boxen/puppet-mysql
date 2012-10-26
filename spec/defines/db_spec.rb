require 'spec_helper'

describe 'mysql::db' do
  let(:facts) do
    { :boxen_home => '/opt/boxen' }
  end
  let(:title) { 'name' }

  it { should include_class('mysql') }
  it "creates the database" do
    should contain_exec("mysql-db-#{title}").
           with(
             :command => "mysqladmin -uroot create #{title}",
             :creates => "/opt/boxen/data/mysql/#{title}"
           )
  end
end
