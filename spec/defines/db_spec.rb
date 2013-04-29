require 'spec_helper'

describe 'mysql::db' do
  let(:facts) do
    { :boxen_home => '/opt/boxen' }
  end
  let(:title) { 'name' }

  context "when ensure is present" do
    let(:params) do
      { :ensure => 'present' }
    end

    it { should include_class('mysql') }

    it "creates the database" do
      should contain_exec("create mysql db #{title}").
             with(
               :command => "mysqladmin -uroot create #{title}",
               :creates => "/opt/boxen/data/mysql/#{title}"
             )
    end
  end

  context "when ensure and user are present" do
    let(:params) do
      { :ensure => 'present',
        :user => "dbuser" }
    end

    it { should include_class('mysql') }

    it "creates the database" do
      should contain_exec("create mysql db #{title}").
             with(
               :command => "mysqladmin -uroot create #{title}",
               :creates => "/opt/boxen/data/mysql/#{title}"
             )
    end

    it "creates the correct user" do
      should contain_exec("create user dbuser with ALL permissions on % to #{title}").
             with(
               :command => "mysql -uroot -e \"CREATE USER 'dbuser'@$'%' IDENTIFIED BY 'password'; GRANT ALL PRIVILEGES ON #{title} . * TO 'dbuser'@$'%'; FLUSH PRIVILEGES;\""
             )
    end
  end

  context "when ensure is absent" do
    let(:params) do
      { :ensure => 'absent' }
    end

    it { should include_class('mysql') }
    it { should_not contain_exec("create mysql db #{title}") }

    it "destroys the database" do
      should contain_exec("delete mysql db #{title}").
             with(
               :command => "mysqladmin -uroot drop database #{title}"
             )
    end
  end
end
