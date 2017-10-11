module Existence

  module Services

    class ServiceBase

      def initialize(config: Configuration, **)
        @config = config.config
      end

      def user_bearer(user)
        user.jwt
      end

      def check_authorisation(decision_point: ,action:)
        decision_point.(resource: self.class::RESOURCE, action: action)
      end

      private

      def oauth_client_credentials
        { client_id: @config.client_id, client_secret: @config.client_secret }
      end


    end

  end

end
