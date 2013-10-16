require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'netscaler'
require 'netscaler/mock_adapter'

describe Netscaler::ServiceGroup do

  connection = Netscaler::Connection.new 'hostname' => 'foo', 'password' => 'bar', 'username' => 'bar'

  context 'when adding a new servicegroup' do

    it 'a name is required' do
      #netscaler.adapter = Netscaler::MockAdapter.new :status_code=>400, :body => '{ "errorcode": 1095, "message": "Required argument missing [name]", "severity": "ERROR" }',

      expect {
        connection.servicegroups.add_servicegroup({ 'serviceType' => 'tcp' })
      }.to raise_error(ArgumentError, /serviceGroupName/)
    end

    it 'a service type is required' do
      expect {
        connection.servicegroups.add_servicegroup({ 'serviceGroupName' => 'test-serviceGroup' })
      }.to raise_error(ArgumentError, /serviceType/)
    end

  end

  context 'when binding a new lbmonitor to servicegroup' do

    it 'a Service group name is required' do
      expect {
        connection.servicegroups.lbmonitor_servicegroup_binding({ 'monitorName' => 'TCP' })
      }.to raise_error(ArgumentError, /serviceGroupName/)
    end

    it 'a lbmonitor name is required' do
      expect {
        connection.servicegroups.lbmonitor_servicegroup_binding({ 'serviceGroupName' => 'test-serviceGroup' })
      }.to raise_error(ArgumentError, /monitorName/)
    end

  end

  context 'when unbinding a lbmonitor from servicegroup' do

    it 'a Service group name is required' do
      expect {
        connection.servicegroups.lbmonitor_servicegroup_binding({ 'monitorName' => 'TCP' })
      }.to raise_error(ArgumentError, /serviceGroupName/)
    end

    it 'a lbmonitor name is required' do
      expect {
        connection.servicegroups.lbmonitor_servicegroup_binding({ 'serviceGroupName' => 'test-serviceGroup' })
      }.to raise_error(ArgumentError, /monitorName/)
    end

  end
  
  context 'when binding a new server to servicegroup' do

    it 'a Service group name is required' do
      expect {
        connection.servicegroups.bind_servicegroup_servicegroupmember({ 'port'=> '8080', 'ip' => '199.199.199.199' })
      }.to raise_error(ArgumentError, /serviceGroupName/)
    end

    it 'an IP address is required' do
      expect {
        connection.servicegroups.bind_servicegroup_servicegroupmember({ 'serviceGroupName' => 'test-serviceGroup', 'port' => '8080' })
      }.to raise_error(ArgumentError, /ip/)
    end

    it 'a port is required' do
      expect {
        connection.servicegroups.bind_servicegroup_servicegroupmember({ 'serviceGroupName' => 'test-serviceGroup', 'ip' => '199.199.199.199' })
      }.to raise_error(ArgumentError, /port/)
    end

  end

  context 'when unbinding a server from servicegroup' do

    it 'a Service group name is required' do
      expect {
        connection.servicegroups.unbind_servicegroup_servicegroupmember({ 'port' => '8080', 'ip' => '199.199.199.199' })
      }.to raise_error(ArgumentError, /serviceGroupName/)
    end

    it 'an IP address is required' do
      expect {
        connection.servicegroups.unbind_servicegroup_servicegroupmember({ 'serviceGroupName' => 'test-serviceGroup', 'port' => '8080' })
      }.to raise_error(ArgumentError, /ip/)
    end

    it 'a port is required' do
      expect {
        connection.servicegroups.unbind_servicegroup_servicegroupmember({ 'serviceGroupName' => 'test-serviceGroup', 'ip' => '199.199.199.199' })
      }.to raise_error(ArgumentError, /port/)
    end

  end
  
end
