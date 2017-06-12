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
        Right(account: account, scoping_user: scoping_user_token, authorising_token: authorising_token).bind do |input|
          perform_get_clients(account, scoping_user_token, authorising_token)
        end.bind do |result|
          @clients = result
          Right(self)
        end.or do |error|
          service_error(error)
        end
      end

      def each(&block)
        @clients.each(&block)
      end

      def empty?
        @clients.empty?
      end

      private

      def perform_get_clients(account, scoping_user_token, authorising_token)
        @client.feed(account, scoping_user_token, authorising_token)
      end

    end

  end

end
