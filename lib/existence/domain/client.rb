require_relative '../adapters/create_client_command'
require_relative '../adapters/get_client_feed_command'
require_relative 'client_value'
require_relative 'domain_base'

module Existence

  module Domain

    class Client < DomainBase

      include Dry::Monads::Either::Mixin
      extend Dry::Monads::Either::Mixin

      class << self

        def feed(account, scoping_user_token, authorising_token)
          Right(account: account, scoping_user_token: scoping_user_token, authorising_token: authorising_token).bind do |input|
            perform_get_clients(input[:account], input[:scoping_user_token], input[:authorising_token])
          end.bind do |clients_feed|
            binding.pry
            Right(clients_feed["accounts"].map {|client| new().build(client) })
          end.or do |error|
            binding.pry
            Left(error)
          end
        end

        def perform_get_clients(account, scoping_user_token, authorising_token)
          get_client_feed_adapter.new.(resource: account.clients_feed_link,
                                       params: { scoping_user: scoping_user_token },
                                       jwt: authorising_token)
        end

        def get_client_feed_adapter
          Adapters::GetClientFeedCommand
        end

      end # class methods

      def initialize(create_command_adapter: Adapters::CreateClientCommand,
                     client_value: Domain::ClientValue)
        super
        @client_value = client_value
        @create_command_adapter = create_command_adapter
      end

      def build(client)
        client_value(client)
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

      # {"@type"=>"oauth_client",
      #  "id"=>"f9691db4-fd75-4277-9186-b6565070050b",
      #  "name"=>"app1",
      #  "client_id"=>"1b3b6hb4rxw0uhnsum90zg2r2ixl92d2bkxxzluvefxqrv8wmx",
      #  "client_secret"=>"84hbpxn9sqkzs173qmtum12mc3j27bxhlll5dxzu35mn1khnh",
      #  "links"=>
      #   [{"rel"=>"self", "href"=>"/api/oauth_clients/f9691db4-fd75-4277-9186-b6565070050b"},
      #    {"rel"=>"client_account", "href"=>"/api/client_accounts/23f34d9a-8d33-440a-b271-8f5a9d1553c4"}]}
      def client_value(result)
        @client_value.new(type:           result["@type"],
                          id:             result["id"],
                          name:           result["name"],
                          client_id:      result["client_id"],
                          client_secret:  result["client_secret"],
                          links:          build_links(type: result["@type"], links: result["links"], id: result["id"]))
      end

    end
  end
end
