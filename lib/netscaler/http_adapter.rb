require 'rest-client'
require 'json'
require 'hashr'

module Netscaler
  class HttpAdapter

    def initialize(args)
      @site = RestClient::Resource.new(args[:hostname])
      @credentials = args[:credentials]
    end

    def post_no_body(part, data, args={})
      url = get_uri(part)
      options = prepare_options(args)
      options[:content_type] = :json#'application/json'

      post_data = prepare_payload(data)
      @site[url].post post_data, options
    end

    def post(part, data, args={})
      url = get_uri(part)
      options = prepare_options(args)
      options[:content_type] = :json#'application/json'

      post_data = prepare_payload(data)
      @site[url].post post_data, options do |response, request, result|
        return process_result(result, response)
      end
    end

    def get(part, args={})
      url = get_uri(part)
      headers = {}
      options = prepare_options(args.merge(headers))

      @site[url].get(options) do |response, request, result|
        return process_result(result, response)
      end

    end

    protected

    def prepare_payload(data)
      if data.is_a?(String)
        post_data = data
      else
        post_data = data.to_json
      end
      return post_data
    end

    def prepare_options(args)
      options = {
          :cookies=>{}
      }
      unless @session.nil?
        options[:cookies]['NITRO_AUTH_TOKEN'] = @session
      end
      options[:accept] = :json
      options[:params] = args[:params] if args.has_key?(:params)
      if @credentials
        options['X-NITRO-USER'] = @credentials[:username]
        options['X-NITRO-PASS'] = @credentials[:password]
        options['Content-Type'] = 'application/vnd.com.citrix.netscaler.lbvserver+json'
      end
      return options
    end

    def check_error(payload)
      if payload['severity'] =~ /error/i
        raise ArgumentError, "ErrorCode #{payload['errorcode']} Severity #{payload['severity']} -> #{payload['message']}"
      end
    end

    def process_result(result, response)
      #status_code = result.code.to_i

      if result.header['content-type'] =~ /application\/json/
        payload = JSON.parse(response)
        check_error(payload)
        return Hashr.new payload
      else
        raise Exception, 'Shit is broke'
      end
    end

    def get_uri(part)
      url = 'nitro/v1/'
      return url + part
    end

  end
end