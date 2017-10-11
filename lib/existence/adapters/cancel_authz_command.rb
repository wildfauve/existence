require_relative 'adapter_base'

module Existence

  module Adapters

    class CancelAuthzCommand < AdapterBase

      def initialize(config: Configuration)
        super
      end

      def call(cancel_link: , jwt:)
        delete_to_port(jwt, cancel_link)
      end

      private

      def delete_to_port(jwt, cancel_link)
        port.new.delete_to_port(credentials: bearer_token(jwt),  service: service, resource: cancel_link)
      end

      def resource
        @config.resources.authz
      end


    end

  end

end
