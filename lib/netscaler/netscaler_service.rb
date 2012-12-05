module Netscaler
  class NetscalerService

    :protected
    def validate_payload(payload, required_args)
      raise ArgumentError, 'payload must be a hash.' unless payload.is_a?(Hash)
      missing_args=[]
      required_args.each do |arg|
        missing_args << arg unless payload.has_key?(arg)
      end

      raise ArgumentError, "Missing required arguments. #{missing_args.join(', ')}"
    end
  end
end