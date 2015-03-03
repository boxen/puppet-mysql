require 'spec_helper'

describe 'mysql::user::grant' do
  let(:facts) { default_facts }
  let(:title) { 'name' }
  let(:user) { 'user' }
  let(:database) { 'database' }

  context "when ensure is present" do
    let(:params) do
      { :username => user,
        :database => database }
    end

    it { should contain_class('mysql') }
    it { should contain_mysql_grant('name') }
  end


  context "when ensure is absent" do
    let(:params) do
      { :ensure   => 'absent',
        :username => user,
        :database => database }
    end

    it { should contain_class('mysql') }
    it { should_not contain_exec("granting #{user} access to #{database}") }
  end
end
