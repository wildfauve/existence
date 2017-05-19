require_relative '../adapters/get_account_command'
require_relative '../adapters/create_account_command'
require_relative 'domain_base'
require_relative 'account_value'

module Existence

  module Domain

    class Account < DomainBase

      include Dry::Monads::Either::Mixin

      def initialize(get_command_adapter: Adapters::GetAccountCommand,
                     create_command_adapter: Adapters::CreateAccountCommand,
                     account_value: Domain::AccountValue)
        super
        @account_value = account_value
        @get_command_adapter = get_command_adapter
        @create_command_adapter = create_command_adapter
      end

      def create(account_params:, authorising_token: )
        Right(account_params: account_params, authorising_token: authorising_token).bind do |input|
          perform_create_account(account_params, authorising_token)
        end.bind do |result|
          Right(account_value(result))
        end.or do |error|
          service_error(error)
        end
      end

      def build(account)
        Right(account_value(account))
      end

      private

      def perform_create_account(account_params, authorising_token)
        @create_command_adapter.new.(params: account_params, jwt: authorising_token)
      end

      def account_value(result)
        @account_value.new(type: result["@type"],
                           id: result["id"],
                           name: result["name"],
                           state: result["state"],
                           links: build_links(result["@type"], result["links"]))
      end

      def mock_get_value
      end

      def mock_cancel_value
        nil
      end

    end

  end

end
