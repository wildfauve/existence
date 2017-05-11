require_relative 'adapter_base'
require_relative '../domain/oauth_token_value'

module Existence

  module Adapters

    class GetTokenCommand < AdapterBase

      SUCCESS = :ok

      def initialize(oauth_token_value: Domain::OauthTokenValue)
        super
        @oauth_token_value = oauth_token_value
      end

      def call(params:, credentials:, service: ENV['TOKEN_ENDPOINT'] )
        result(send_to_port(params, credentials, service))
      end

      # overrides default value
      def value(result)
        @oauth_token_value.new(
                                token_type: result["token_type"],
                                access_token: result["access_token"],
                                refresh_token: result["refresh_token"],
                                id_token: result["id_token"],
                                expires_in: result["expires_in"]
        )
      end

      private

      def send_to_port(params, credentials, service)
        return Right(OpenStruct.new(body: mock_token_value, status: :ok)) if @config.config.mock
        @port.new.send_on_port(params: params, credentials: basic_auth_token(credentials), service: service, resource: resource)
      end

      def resource
        @config.resource_for(:token)
      end

      def mock_token_value
        {
          "token_type" => "Bearer",
          "access_token" => "4yemfk9tje3tu5bhjbfnwzkxg1enyc",
          "id_token" => "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJpZGVudGl0eS5taW5kYWluZm8uaW8iLCJzdWIiOiJhYzlkNGJjNC01MGMwLTRjZTEtYjdkYy0xZTBlYTY2ZTFmYjQiLCJhdWQiOiJlYzdkYzU0ZS0yOTgyLTQ3YzUtYmMwOS1iZTBhYzJlODJhMzAiLCJleHAiOjE0OTkxMTE4OTYsImFtciI6W10sImlhdCI6MTQ5Mzg0MTQ5NiwiYXpwIjoiZWM3ZGM1NGUtMjk4Mi00N2M1LWJjMDktYmUwYWMyZTgyYTMwIn0.NivJxn5nUSIw6FE6Y_ysFfkU7LNKl2cEE3SQU8G-0oCBbVQnWbg26bTtlZ9_2K1k3lofvVehSBC3NgmCdEBn9b6Ap1QPmR26ccr9BfboxZ_6nAJRWo0PR-Enan8QPAYn-nyqEa_9yKeWHE7TVD_dgk-soHQT_lfM_-0IhqxA-qGlpq1yCCxQkEuM0Tkf5rEokkmLNAZE82Eikf3_brJW99AvoJw8cVWQlCsKM654QQMZw56_ou2E4L_v70iMZdi2Dk9KawaLcJDqJdLr3LXF6b_lEUu9gkjaz-OMDUWNQQqd_hdB-N4WXFJ1QXPbzXOc1XFWMuTdjok_7jBRYKWaEQ",
          "expires_in" => "5183998"
        }
      end


    end # class

  end
end
