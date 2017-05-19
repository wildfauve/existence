require_relative 'adapter_base'

module Existence

  module Adapters

    class GetAccountCommand < AdapterBase

      def initialize(config: Configuration)
        super
        @config = config
      end

      def call(params: , jwt:)
        result(get_from_port(params, jwt))
      end

      private

      def get_from_port(params, jwt)
        return Right(OpenStruct.new(body: mock_account_collection, status: :ok)) if @config.config.mock
        port.new.get_from_port(query_params: params, credentials: bearer_token(jwt),  service: service, resource: resource)
      end

      def resource
        @config.resource_for(:accounts)
      end

      def mock_account_collection
        {
          "@type" => "client_accounts_feed",
          "accounts" => [
            {
              "@type" => "client_account",
              "id"=>"api/client_accounts/1",
              "name"=>"An Account"
            },
            {
              "@type" => "client_account",
              "id"=>"api/client_accounts/1",
              "name"=>"Another Account"
            }
          ],
          "links" => [{"rel"=>"self", "href"=>"/api/client_accounts"}]
        }
      end


    end

  end

end
