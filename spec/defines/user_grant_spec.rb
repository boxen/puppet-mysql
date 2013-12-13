require 'spec_helper'

describe 'mysql::user::grant' do
  let(:facts) do
    { :boxen_home => '/opt/boxen' }
  end
  let(:title) { 'name' }
  let(:user) { 'user' }
  let(:database) { 'database' }

  context "when ensure is present" do
    let(:params) do
      { :username => user,
        :database => database }
    end

    it { should include_class('mysql') }
    end
  end


  context "when ensure is absent" do
    let(:params) do
      { :ensure   => 'absent',
        :username => user,
        :database => database }
    end

    it { should include_class('mysql') }
    it { should_not contain_exec("granting #{user} access to #{database}") }
    end
  end
end
