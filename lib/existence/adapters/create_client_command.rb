require_relative 'adapter_base'

module Existence

  module Adapters

    class CreateClientCommand < AdapterBase

      def initialize(config: Configuration)
        super
        @config = config
      end

      def call(params: , jwt:)
        result(send_to_port(params, jwt))
      end

      private

      def send_to_port(params, jwt)
        # return Right(OpenStruct.new(body: mock_create_acct_value, status: :ok)) if @config.config.mock
        port.new.send_on_port(params: params,
                              credentials: bearer_token(jwt),
                              service: service,
                              resource: resource,
                              encoding: :json )
      end

      def resource
        @config.resource_for(:oauth_clients)
      end

      def mock_create_client_value
        {
        }
      end


    end

  end

end
