module Existence
  module Domain

    class IdentityTokenValue < Dry::Struct

      attribute :refresh_token, Types::String
      attribute :access_token, Types::String
      attribute :jwt, Types::String
      attribute :expires_at, Types::Time
      attribute :iss, Types::String
      attribute :sub, Types::String
      attribute :aud, Types::String
      attribute :exp, Types::String
      attribute :iat, Types::String
      attribute :azp, Types::String
    end

  end
end
