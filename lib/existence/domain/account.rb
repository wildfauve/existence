require_relative '../adapters/get_account_feed_command'
require_relative '../adapters/get_account_command'
require_relative '../adapters/create_account_command'
require_relative '../adapters/get_client_feed_command'
require_relative 'clients_feed'
require_relative 'domain_base'
require_relative 'account_value'

module Existence

  module Domain

    class Account < DomainBase

      include Dry::Monads::Either::Mixin
      extend Dry::Monads::Either::Mixin
      extend Forwardable

      class << self

        def feed(scoping_user_token, authorising_token)
          Right(scoping_user_token: scoping_user_token, authorising_token: authorising_token).bind do |input|
            perform_get_accounts(input[:scoping_user_token], input[:authorising_token])
          end.bind do |accounts_feed|
            Right(accounts_feed["accounts"].map {|acct| new().build(acct) })
          end.or do |error|
            binding.pry
            Left(error)
          end
        end

        def find(id: , scoping_user_token: , authorising_token:)
          Right(id: id, scoping_user_token: scoping_user_token, authorising_token: authorising_token).bind do |input|
            perform_get_account(input)
          end.bind do |account|
            Right(new().build(account))
          end.bind do |account|
            account.client_feed(scoping_user_token, authorising_token)
          end.or do |error|
            Left(error)
          end
        end

        def perform_get_accounts(scoping_user_token, authorising_token)
          get_account_feed_adapter.new.(params: { scoping_user: scoping_user_token }, jwt: authorising_token)
        end

        def perform_get_account(params)
          get_account_adapter.new.(params: { scoping_user: params[:scoping_user_token] },
                                   jwt: params[:authorising_token],
                                   resource: params[:id])
        end

        def accounts_value(result)
          @accounts = result["accounts"].map { |account| @account.new.build(account).value }
        end

        def get_account_adapter
          Adapters::GetAccountCommand
        end

        def get_account_feed_adapter
          Adapters::GetAccountFeedCommand
        end



      end

      def_delegators :@value, :name, :id, :links, :type, :state

      attr_reader :value, :clients

      def initialize(get_command_adapter: Adapters::GetAccountFeedCommand,
                     create_command_adapter: Adapters::CreateAccountCommand,
                     get_client_feed_adapter: Adapters::GetClientFeedCommand,
                     account_value: Domain::AccountValue,
                     clients_feed: Domain::ClientsFeed)
        super
        @account_value = account_value
        @get_command_adapter = get_command_adapter
        @create_command_adapter = create_command_adapter
        @get_client_feed_adapter = get_client_feed_adapter
        @clients_feed = clients_feed
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
        account_value(account)
        self
      end

      def client_feed(scoping_user_token, authorising_token)
        feed = @clients_feed.new.feed(account: self, scoping_user_token: scoping_user_token, authorising_token: authorising_token)
        if feed.success?
          @clients = feed.value
          Right(self)
        else
          feed
        end
      end

      def clients_feed_link
        @value.links.detect {|l| l.rel == @config.rels.oauth_clients_feed}
      end

      def self_link
        @value.links.detect {|l| l.rel == @config.rels.client_account}
      end

      private

      def perform_create_account(account_params, authorising_token)
        @create_command_adapter.new.(params: account_params, jwt: authorising_token)
      end

      def account_value(result)
        @value = @account_value.new(type: result["@type"],
                           id: result["id"],
                           name: result["name"],
                           state: result["state"],
                           links: build_links(type: result["@type"], links: result["links"], id: result["id"] ) )
      end

      def mock_get_value
      end

      def mock_cancel_value
        nil
      end

    end

  end

end
