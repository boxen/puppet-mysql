require 'spec_helper'

describe 'mysql::user::grant' do
  let(:facts) do
    { :boxen_home => '/opt/boxen' }
  end
  let(:title) { 'name' }
  let(:user) { 'user' }
  let(:database) { 'database' }
  let(:host) { '%' }
  let(:grants) { 'ALL' }

  context "when ensure is present" do
    let(:params) do
      { :username => user,
        :database => database }
    end

    it { should include_class('mysql') }

    it "creates the grant" do
      should contain_exec("granting #{user} access to #{database} @ localhost").
             with(
               :command => "mysql -uroot -p13306 --password='' \
        -e \"grant ALL on #{database}.* to '#{user}'@'localhost'; \
        flush privileges;\""
        )
    end
  end

  context "when setting the host" do
    let(:params) do
      { :username => user,
        :database => database,
        :host     => host }
    end

    it "properly quotes the host" do
      should contain_exec("granting #{user} access to #{database} @ #{host}").
             with(
               :command => "mysql -uroot -p13306 --password='' \
        -e \"grant ALL on #{database}.* to '#{user}'@'#{host}'; \
        flush privileges;\"",
               :unless  => "mysql -uroot -p13306 -e 'SHOW GRANTS FOR #{user}@'#{host}';' \
        --password='' | grep -w '#{database}' | grep -w '#{grants}'"
        )
    end
  end


  context "when ensure is absent" do
    let(:params) do
      { :ensure   => 'absent',
        :username => user,
        :database => database }
    end

    it { should include_class('mysql') }
    it { should_not contain_exec("granting #{user} access to #{database} @ #{host}") }

    it "revokes the users privs" do
      should contain_exec("removing #{user} access to #{database} @ localhost").
             with(
               :command => "mysql -uroot -p13306 --password='' \
        -e \"REVOKE ALL PRIVILEGES on #{database}.* to '#{user}'@'localhost'; \
        flush privileges;\""
             )
    end
  end
end
