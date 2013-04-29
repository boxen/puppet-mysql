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
        :user => "dbuser",
        :password => "god" }
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
               :command => "mysql -uroot -e \" GRANT ALL PRIVILEGES ON #{title} . * TO 'dbuser'@'%' IDENTIFIED BY 'god'; GRANT ALL PRIVILEGES ON #{title} . * TO 'dbuser'@'localhost' IDENTIFIED BY 'god'; FLUSH PRIVILEGES;\""
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

  context "when ensure is absent and user is present" do
    let(:params) do
      { :ensure => 'absent', :user => 'dbuser' }
    end

    it { should include_class('mysql') }
    it { should_not contain_exec("create mysql db #{title}") }

    it "destroys the database" do
      should contain_exec("delete mysql db #{title}").
             with(
               :command => "mysqladmin -uroot drop database #{title}"
             )
    end

    it "destroys the correct user" do
      should contain_exec("drop user dbuser@%").
             with(
               :command => "mysql -uroot -e \" GRANT USAGE ON *.* TO 'dbuser'@'%'; DROP USER 'dbuser'@'%'; GRANT USAGE ON *.* TO 'dbuser'@'localhost'; DROP USER 'dbuser'@'localhost'; FLUSH PRIVILEGES;\""
             )
    end
  end
end
