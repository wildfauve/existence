require_relative 'jwt_value'
require_relative 'domain_base'

module Existence

  module Domain

    class Jwt < DomainBase

      include Dry::Monads::Either::Mixin
      include Dry::Monads::Try::Mixin


      def initialize(jwt_value: Domain::JwtValue)
        super
        @jwt_value = jwt_value
      end

      def call(oauth_token)
        Right(oauth_token).bind do |oauth_token|
          decode(oauth_token.id_token)
        end.bind do |id_token|
          jwt_value(oauth_token, id_token)
        end.or do |error|
          Left(error)
        end
      end

      private

      def jwt_value(oauth_token, id_token)
        Right(@jwt_value.new(oauth_token: oauth_token, jwt: oauth_token.id_token, decoded_jwt: id_token))
      end

      def decode(jwt)
        Try(JSON::JWT::InvalidFormat) { decode!(jwt) }
      end

      def decode!(jwt)
        return nil if jwt.nil?
        decoded_jwt = JSON::JWT.decode(jwt, @config.identity_public_key)
        jwt_expired?(decoded_jwt) ? nil : decoded_jwt
      end

      def jwt_expired?(decoded_jwt)
        decoded_jwt["exp"] ? decoded_jwt["exp"].to_i < Time.now.to_i : false
      end


    end

  end

end
