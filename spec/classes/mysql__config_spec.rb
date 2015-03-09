require "spec_helper"

describe "mysql::config" do
  let(:facts) { default_facts }
  let(:params) {
    {
      "ensure" => "present",
      "configdir" => "/test/boxen/config/mysql",
      "globalconfigprefix" => "/test/boxen/homebrew",
      "bindir" => "/test/boxen/homebrew/bin",
      "datadir" => "/test/boxen/data/mysql",
      "executable" => "/test/boxen/homebrew/bin/mysql",
      "logdir" => "/test/boxen/log/mysql",
      "host" => "127.0.0.1",
      "port" => "13306",
      "socket" => "/test/boxen/sockets/mysql",
      "user" => "boxenuser"
    }
  }

  it do
    %w(config data log).each do |d|
      should contain_file("/test/boxen/#{d}/mysql").with_ensure(:directory)
    end

    should contain_file("/test/boxen/config/mysql/my.cnf")
  end
end
