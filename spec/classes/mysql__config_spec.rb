require "spec_helper"

describe "mysql::config" do
  let(:facts) { default_facts }

  it do
    %w(config data log).each do |d|
      should contain_file("/test/boxen/#{d}/mysql").with_ensure(:directory)
    end

    should contain_file("/test/boxen/config/mysql/my.cnf")

    should contain_file('/Library/LaunchDaemons/dev.mysql.plist')
  end
end
