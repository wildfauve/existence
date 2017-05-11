module Existence
  module Domain

    # This value object wraps the response from Identity's get token request.
    # This is the raw token

    class OauthTokenValue < Dry::Struct

      attribute :token_type, Types::String
      attribute :access_token, Types::String
      attribute :refresh_token, Types::String
      attribute :id_token, Types::String
      attribute :expires_in, Types::Int

    end

  end
end
