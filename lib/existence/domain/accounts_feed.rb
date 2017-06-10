require_relative 'account'

module Existence

  module Domain

    class AccountsFeed < DomainBase

      include Dry::Monads::Either::Mixin
      include Enumerable

      def initialize(account: Domain::Account)
        super
        @account = account
      end

      def feed(scoping_user_token:, authorising_token:)
        Right(scoping_user: scoping_user_token, authorising_token: authorising_token).bind do |input|
          perform_get_accounts(scoping_user_token, authorising_token)
        end.bind do |result|
          @accounts = result
          Right(self)
        end.or do |error|
          binding.pry
          service_error(error)
        end
      end

      def each(&block)
        @accounts.each(&block)
      end

      def empty?
        @accounts.empty?
      end

      private

      def perform_get_accounts(scoping_user_token, authorising_token)
        @account.feed(scoping_user_token, authorising_token)
      end

    end

  end

end
