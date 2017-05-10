require './lib/existence/ports/identity_port'

module Existence

  module Adapters

    class AdapterBase

      include Dry::Monads::Either::Mixin

      SUCCESS = :ok

      attr_reader :port

      def initialize(port: Ports::IdentityPort, **) #oauth_token_value: Domain::OauthTokenValue
        @port = port
        # @oauth_token_value = oauth_token_value
      end

      def result(result)
        return Left(nil) if result.failure? || (result.value.status == :system_failure)
        Right(value(result.value.body))
      end

      # overridden by adapters that wish to return a non-port value.
      def value(result)
        result
      end

      def bearer_token(jwt)
        "Bearer #{jwt}"
      end

      def basic_auth_token(credentials)
        basic_credentials(credentials[:client_id], credentials[:client_secret])
      end

      def basic_credentials(user, secret)
        Base64.strict_encode64("#{user}:#{secret}")
      end

    end

  end

end
