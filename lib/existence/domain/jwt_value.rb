module Existence

  module Domain

    class JwtValue < Dry::Struct
      attribute :jwt,           Types::String
      attribute :oauth_token,   Types::Class
      attribute :decoded_jwt,   Types::Hash
    end

  end
end
