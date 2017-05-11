require_relative '../domain/identity_token'

module Existence

  module Services

    class GetTokenService < ServiceBase

      include Dry::Monads::Either::Mixin

      def initialize(identity_token: Domain::IdentityToken)
        super
        @identity_token = identity_token
      end

      def call(code, redirect_uri, oauth_grant_type)
        # TODO: validation and error object
        Right(code: code, redirect_uri: redirect_uri, oauth_grant_type: oauth_grant_type).bind do |input|
          get_token(input)
        end.bind do |result|
          Right(result)
        end.or do |error|
          Left(nil)
        end
      end

      private

      def get_token(params)
        @identity_token.new.(params: params, credentials: oauth_client_credentials)
      end

    end

  end

end
