require 'spec_helper'

describe 'mysql::import_tz' do
  let(:facts) do
    { :boxen_home => '/opt/boxen'}
  end

  context 'importing timezones' do
    it { should include_class('mysql') }

    it 'should import system timezone data into MySQL' do
      should contain_exec('import timezone data').with(
        :command => 'mysql_tzinfo_to_sql /usr/share/zoneinfo/ | mysql -h 127.0.0.1 -u root mysql'
      )
    end
  end
end