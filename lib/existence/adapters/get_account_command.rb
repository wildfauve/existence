require_relative 'adapter_base'

module Existence

  module Adapters

    class GetAccountCommand < AdapterBase

      def initialize(config: Configuration)
        super
      end

      def call(params: , jwt:, resource:)
        result(get_from_port(params, jwt, resource))
      end

      private

      def get_from_port(params, jwt, resource)
        return Right(OpenStruct.new(body: mock_account, status: :ok)) if @config.mock
        port.new.get_from_port(query_params: params, credentials: bearer_token(jwt),  service: service, resource: resource)
      end

      def mock_account
        {
          "@type": "client_account",
          "id": "41cd850d-ae17-4748-b29c-b21e33dd5718",
          "name": "Acct3",
          "state": "prospect",
          "links": [
            {
              "rel": "self",
              "href": "/api/client_accounts/41cd850d-ae17-4748-b29c-b21e33dd5718"
            },
            {
              "rel": "oauth_clients_feed",
              "href": "/api/client_accounts/41cd850d-ae17-4748-b29c-b21e33dd5718/oauth_clients"
            }
          ]
        }
      end


    end

  end

end
