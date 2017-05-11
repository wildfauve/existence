require_relative 'adapter_base'

module Existence

  module Adapters

    class GetUserAuthzCommand < AdapterBase

      def initialize(config: Configuration)
        super
        @config = config
      end

      def call(params: , jwt:)
        result(get_from_port(params, jwt))
      end

      private

      def get_from_port(params, jwt)
        port.new.get_from_port(query_params: params, credentials: bearer_token(jwt),  service: service, resource: resource)
      end

      def resource
        @config.resource_for(:authz)
      end


    end

  end

end
