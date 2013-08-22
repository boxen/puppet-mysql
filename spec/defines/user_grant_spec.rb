require 'spec_helper'

describe 'mysql::user::grant' do
  let(:facts) do
    { :boxen_home => '/opt/boxen' }
  end
  let(:title) { 'name' }
  let(:user) { 'user' }

  context "when ensure is present" do
    let(:params) do
      { :username => user }
    end

    it { should include_class('mysql') }

    it "creates the grant" do
      should contain_exec("granting #{user} access to #{title}").
             with(
               :command => "mysql -uroot -p13306 --password=''\
       -e \"grant ALL on #{title}.* to '#{user}'@'localhost'; flush privileges;\""
        )
    end
  end

end
