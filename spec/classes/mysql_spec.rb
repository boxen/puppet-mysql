require 'spec_helper'

describe 'mysql' do
  let(:facts) { default_facts }

  it do
    should include_class('mysql::config')
    should include_class('mysql::package')
    should include_class('mysql::service')
  end
end
