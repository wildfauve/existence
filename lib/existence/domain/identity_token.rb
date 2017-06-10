require_relative '../adapters/get_token_command'
require_relative 'identity_token_value'
require_relative 'jwt'

module Existence

  module Domain

    class IdentityToken < DomainBase

      AUTHORISATION_CODE       = "authorization_code"
      CLIENT_CREDENTIALS_GRANT = "client_credentials"

      include Dry::Monads::Either::Mixin

      attr_reader :adapter

      def initialize(adapter: Adapters::GetTokenCommand,
                     token_value: Domain::IdentityTokenValue,
                     jwt: Domain::Jwt)
        @adapter = adapter
        @token_value = token_value
        @jwt = jwt
      end

      def call(params:, credentials: )
        Right(params: params, credentials: credentials).bind do |input|
          get_token(self.send(params[:oauth_grant_type], params[:code], params[:redirect_uri], credentials), credentials)
        end.bind do |oauth_token|
          @jwt.new.(oauth_token)
        end.bind do |tokens|
          Right(token_value(tokens))
        end.or do |error|
          Left(nil)
        end
      end

      private

      def auth_code_grant_params(code, uri, credentials)
        {
          code: code,
          grant_type: AUTHORISATION_CODE,
          client_id: credentials[:client_id],
          redirect_uri: uri
        }
      end

      def client_credentials_grant_params(code, uri, **)
        {
          grant_type: CLIENT_CREDENTIALS_GRANT,
        }
      end


      def get_token(params, credentials)
        @adapter.new.(params: params, credentials: credentials)
      end

      def token_value(token)
        @token_value.new( access_token: token.oauth_token.access_token,
                          refresh_token: token.oauth_token.refresh_token,
                          jwt: token.jwt,
                          expires_at: time_at(token.decoded_jwt["exp"]),
                          iss: token.decoded_jwt["iss"],
                          sub: token.decoded_jwt["sub"],
                          aud: token.decoded_jwt["aud"],
                          exp: token.decoded_jwt["exp"],
                          iat: token.decoded_jwt["iat"],
                          azp: token.decoded_jwt["azp"]
                         )
      end


      def time_at(at)
        Time.at(at)
      end

    end
  end
end
