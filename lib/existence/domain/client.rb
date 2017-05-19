require_relative '../adapters/create_client_command'
require_relative 'client_value'

module Existence

  module Domain

    class Client < DomainBase

      include Dry::Monads::Either::Mixin

      def initialize(create_command_adapter: Adapters::CreateClientCommand,
                     client_value: Domain::ClientValue)
        super
        @client_value = client_value
        # @get_command_adapter = get_command_adapter
        @create_command_adapter = create_command_adapter
      end

      def create(client_params:, authorising_token: )
        Right(client_params: client_params, authorising_token: authorising_token).bind do |input|
          perform_create_client(client_params, authorising_token)
        end.bind do |result|
          Right(client_value(result))
        end.or do |error|
          service_error(error)
        end
      end

      private

      def perform_create_client(client_params, authorising_token)
        @create_command_adapter.new.(params: client_params, jwt: authorising_token)
      end

    end
  end
end
