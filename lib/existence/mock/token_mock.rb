module Existence

  module Mock

    class TokenMock

      JWT_ALG = :RS256  #RSASSA-PKCS1-v1_5 using SHA-256

      TWODAYS = 60*60*24*2

      def initialize(config: Configuration)
        @config = config
      end

      def generate_id_token(sub)
        JSON::JWT.new(generate_id_token_hash(sub)).sign(@config.identity_private_key, JWT_ALG).to_s
      end

      def generate_id_token_hash(sub)
        {
          iss: "Identity Mock",
          sub: sub,
          aud: "mindainfo",
          exp: Time.now + TWODAYS,
          iat: Time.now.utc.to_i,
          azp: "developer mock"
        }
      end

    end #module

  end # module

end
