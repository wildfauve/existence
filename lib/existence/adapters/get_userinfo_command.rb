require_relative 'adapter_base'

module Existence

  module Adapters

    class GetUserInfoCommand < AdapterBase

      def initialize
        super
      end

      def call(jwt:)
        result(get_from_port(jwt, service))
      end

      private

      def get_from_port(jwt, service)
        port.new.get_from_port(credentials: bearer_token(jwt),  service: service, resource: resource)
      end

      def resource
        @config.resource_for(:userinfo)
      end

    end

  end

end
