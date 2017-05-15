require_relative '../adapters/create_account_command'
require_relative 'domain_base'
require_relative 'account_value'

module Existence

  module Domain

    class Account < DomainBase

      include Dry::Monads::Either::Mixin

      def initialize(create_command_adapter: Adapters::CreateAccountCommand,
                     account_value: Domain::AccountValue)
        super
        @account_value = account_value
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

      private

      def perform_create_account(account_params, authorising_token)
        # return Right(mock_get_value) if @config.config.mock
        @create_command_adapter.new.(params: account_params, jwt: authorising_token)
      end


      def account_value(result)
        @account_value.new(type: result["@type"],
                           id: result["id"],
                           name: result["name"],
                           state: result["state"],
                           links: build_links(result["links"]))
      end

      def build_auth(authz)
        @authz_value.new(
            expires_at:     authz["expires_at"],
            scope:          authz["scope"],
            cancel_link:    link_for("cancel", authz["links"]).fetch("href", nil),
            client: build_client(authz["client"])
        )
      end

      def build_client(client)
        @client_value.new(
            name: client["name"],
            type: client["type"],
            external_client: client["external_client"],
            account_name: client["account"]["name"]
        )
      end

      def link_for(rel, links)
        links.find {|link| link["rel"] == rel}
      end

      def mock_get_value
        {
          "kind"=>"user_authorisations",
          "authorizations"=>
            [
              {"kind"=>"authorisation",
                "created_at"=>"2016-12-01 11:17:23 +1300",
                "expires_at"=>"2017-01-30 11:17:23 +1300",
                "scope"=>[],
                "client"=>{"kind"=>"client", "name"=>"External_1", "type"=>"standard_client", "external_client"=>true, "account"=>{"name" => "External Totalitarian Corporate"}},
                "links"=>[
                  {"rel"=>"cancel", "href"=>"/api/user_authz/d9683368-64c0-45f1-a144-cb0c71b895e2"}
                ]
              }
            ]
          }
      end

      def mock_cancel_value
        nil
      end

    end

  end

end
