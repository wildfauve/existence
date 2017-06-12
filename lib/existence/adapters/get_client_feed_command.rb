require_relative 'adapter_base'

module Existence

  module Adapters

    class GetClientFeedCommand < AdapterBase

      def initialize(config: Configuration)
        super
      end

      def call(resource:, params: , jwt:)
        result(get_from_port(resource, params, jwt))
      end

      private

      def get_from_port(resource, params, jwt)
        return Right(OpenStruct.new(body: mock_account_collection, status: :ok)) if @config.mock
        port.new.get_from_port(query_params: params, credentials: bearer_token(jwt),  service: service, resource: resource)
      end

      def mock_clients_collection
        {
          "@type" => "oauth_clients_feed",
          "oauth_clients" => [
            {
              "@type" => "oauth_client",
              "id" => "/api/client_accounts/a1/oauth_clients/1",
              "name" => "Client 1"
            },
            {
              "@type" => "oauth_client",
              "id" => "/api/client_accounts/a1/oauth_clients/2",
              "name" => "Client 2"
            }
          ],
          "links": [
            {
              "rel": "self",
              "href": "/api/client_accounts/a1/oauth_clients"
            },
            {
              "rel": "client_account",
              "href": "/api/client_accounts/a1"
            }
          ]
        }
      end


    end

  end

end
