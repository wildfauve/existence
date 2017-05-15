require_relative '../ports/identity_port'

module Existence

  module Adapters

    class AdapterBase

      include Dry::Monads::Either::Mixin

      SUCCESS_STATUS = :ok

      attr_reader :port

      def initialize(port: Ports::IdentityPort, config: Configuration, **) #oauth_token_value: Domain::OauthTokenValue
        @port = port
        @config = config
        # @oauth_token_value = oauth_token_value
      end

      private

      def result(result)
        return Left(result.value) if result.failure? || failure_status(result.value.status)
        Right(value(result.value.body))
      end

      # overridden by adapters that wish to return a non-port value.
      def value(result)
        result
      end

      def bearer_token(jwt)
        "Bearer #{jwt}"
      end

      def failure_status(status)
        status != SUCCESS_STATUS
      end

      def basic_auth_token(credentials)
        basic_credentials(credentials[:client_id], credentials[:client_secret])
      end

      def basic_credentials(user, secret)
        Base64.strict_encode64("#{user}:#{secret}")
      end

      def service
        @config.config.identity_host
      end


    end

  end

end
