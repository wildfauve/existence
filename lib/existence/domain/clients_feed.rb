require_relative 'client'

module Existence

  module Domain

    class ClientsFeed < DomainBase

      include Dry::Monads::Either::Mixin
      include Enumerable

      def initialize(client: Domain::Client)
        super
        @client = client
      end

      def feed(account:, scoping_user_token:, authorising_token:)
        binding.pry
        Right(account: account, scoping_user: scoping_user_token, authorising_token: authorising_token).bind do |input|
          perform_get_clients(account, scoping_user_token, authorising_token)
        end.bind do |result|
          binding.pry
          @accounts = result
          Right(self)
        end.or do |error|
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

      def perform_get_clients(account, scoping_user_token, authorising_token)
        @client.feed(account, scoping_user_token, authorising_token)
      end

    end

  end

end
