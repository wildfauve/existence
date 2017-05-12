require_relative 'adapter_base'

module Existence

  module Adapters

    class GetScopesCommand < AdapterBase

      def initialize
        super
      end

      def call
        result(get_from_port(service, resource))
      end

      private

      def get_from_port(service, resource)
        @port.new.get_from_port(service: service, resource: resource)
      end

      def resource
        @config.resource_for(:scopes)
      end

    end

  end

end
