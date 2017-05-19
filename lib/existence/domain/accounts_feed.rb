require_relative 'account'

module Existence

  module Domain

    class AccountsFeed < DomainBase

      include Dry::Monads::Either::Mixin
      include Enumerable

      def initialize(get_command_adapter: Adapters::GetAccountCommand,
                     account: Domain::Account)
        @get_command_adapter = get_command_adapter
        @account = account
      end

      def list(scoping_user_token:, authorising_token:)
        Right(scoping_user: scoping_user_token, authorising_token: authorising_token).bind do |input|
          perform_get_accounts(scoping_user_token, authorising_token)
        end.bind do |result|
          accounts_value(result)
          Right(self)
        end.or do |error|
          service_error(error)
        end
      end

      def each(&block)
        @accounts.each(&block)
      end

      private

      def perform_get_accounts(scoping_user_token, authorising_token)
        @get_command_adapter.new.(params: { scoping_user: scoping_user_token }, jwt: authorising_token)
      end

      def accounts_value(result)
        @accounts = result["accounts"].map { |account| @account.new.build(account).value }
      end

    end

  end

end
