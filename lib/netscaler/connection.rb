require 'rest_client'
require 'uri'
require 'json'

require 'netscaler/server'
require 'netscaler/service'
require 'netscaler/servicegroup'
require 'netscaler/load_balancing'
require 'netscaler/http_adapter'

module Netscaler
  attr_accessor :credentials
  class Connection

    attr_accessor :servers, :servicegroups, :service, :load_balancing, :adapter#, :credentials

    def initialize(options={})
      missing_options=[]
      %w(username password hostname).each do |required_option|
        missing_options << required_option unless options.has_key?(required_option)
      end

      raise ArgumentError, "Required options are missing. #{missing_options.join(', ')}" if missing_options.length > 0
      @credentials = {
        username: options['username'],
        password:  options['password']
      }

      @adapter = HttpAdapter.new hostname: options['hostname'], credentials: @credentials

      @load_balancing = LoadBalancing.new self
      @service = Service.new self
      @servicegroups = ServiceGroup.new self
      @servers = Server.new self
    end

    def login()
      payload = {
        'username' => @credentials[:username],
        'password' => @credentials[:password]
      }

      result = @adapter.post('config/login', { 'login' => payload})
      result['sessionid']
    end

    def logout
      @adapter.post_no_body('config/logout', {'logout'=>{}})
    end
  end
end
