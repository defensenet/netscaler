require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'netscaler'
require 'netscaler/mock_adapter'

describe Netscaler::LoadBalancing do

  before(:all) do
    @connection = Netscaler::Connection.new 'hostname'=> 'nc1.lab5.defense.net', 'password' => '3ZbN048a', 'username'=> 'api'
    #@connection.login
  end

  it 'retrieves a list of servers' do
    record_with_vcr do
      result = @connection.load_balancing.get_lbvservers
      result['lbvserver'].should_not be_nil
    end
  end

  it 'retrieves a list of vserver service bindings' do
    record_with_vcr do
      result = @connection.load_balancing.get_lbvserver_service_binding('defensenet-portal-davehouse-ssl')
      result['lbvserver_service_binding'].should_not be_nil
    end
  end

end
