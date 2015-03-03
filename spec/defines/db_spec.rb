require 'spec_helper'

describe 'mysql::db' do
  let(:facts) { default_facts }
  let(:title) { 'name' }

  context "when ensure is present" do
    let(:params) do
      { :ensure => 'present' }
    end

    it { should include_class('mysql') }

    it "creates the database" do
      should contain_exec("create mysql db #{title}").
             with(
               :command => "/test/boxen/homebrew/bin/mysqladmin -h127.0.0.1 -uroot -p13306 create #{title} --password=''",
               :creates => "/test/boxen/data/mysql/#{title}"
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
               :command => "/test/boxen/homebrew/bin/mysqladmin -h127.0.0.1 -uroot -p13306 drop #{title} --password=''"
             )
    end
  end
end
