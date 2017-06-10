require_relative 'adapter_base'

module Existence

  module Adapters

    class CreateAccountCommand < AdapterBase

      def initialize(config: Configuration)
        super
      end

      def call(params: , jwt:)
        result(send_to_port(params, jwt))
      end

      private

      def send_to_port(params, jwt)
        return Right(OpenStruct.new(body: mock_create_acct_value, status: :ok)) if @config.mock
        port.new.send_on_port(params: params,
                              credentials: bearer_token(jwt),
                              service: service,
                              resource: resource,
                              encoding: :json )
      end

      def resource
        @config.resources.accounts
      end

      def mock_create_acct_value
        {
          "@type" => "client_account",
          "id" => "8e787204-328c-49d6-8f51-4175f5f86ebf",
          "name" => "Account Name",
          "state" => "prospect",
          "links" => [{"rel"=>"self", "href"=>"/api/client_accounts/8e787204-328c-49d6-8f51-4175f5f86ebf"}]
        }
      end


    end

  end

end
