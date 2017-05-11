require_relative '../adapters/get_user_authz_command'
require_relative '../adapters/cancel_authz_command'
require_relative 'authz_value'
require_relative 'client_value'

module Existence

  module Domain

    class Authorisation

      include Dry::Monads::Either::Mixin

      def initialize(authz_value: Domain::AuthzValue,
                     client_value: Domain::ClientValue,
                     cancel_command_adapter: Adapters::CancelAuthzCommand,
                     get_user_command_adapter: Adapters::GetUserAuthzCommand,
                     config: Configuration)
        @get_user_command_adapter = get_user_command_adapter
        @cancel_command_adapter = cancel_command_adapter
        @authz_value = authz_value
        @client_value = client_value
        @config = config
      end

      def get_authorisations(params, credentials)
        Right(params: params, credentials: credentials).bind do |input|
          perform_get_authorisations(input[:params], input[:credentials])
        end.bind do |result|
          Right(authz_value(result))
        end
      end

      def cancel_authorisations(link, credentials)
        Right(link: link, credentials: credentials).bind do |input|
          perform_cancel_authorisations(input[:link], input[:credentials])
        end.bind do |result|
          Right(nil)
        end
      end

      private

      def perform_get_authorisations(params, credentials)
        return Right(mock_get_value) if @config.config.mock
        @get_user_command_adapter.new.(params: params, jwt: credentials)
      end

      def perform_cancel_authorisations(cancel_link, credentials)
        return Right(mock_cancel_value) if @config.config.mock
        @cancel_command_adapter.new.(cancel_link: cancel_link, jwt: credentials)
      end


      def authz_value(authz)
        authz["authorizations"].delete_if {|auth| !auth["client"]["external_client"] }
                               .map {|ext_auth| build_auth(ext_auth)}
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
