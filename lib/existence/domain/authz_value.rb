module Existence
  module Domain

    class AuthzValue < Dry::Struct

      attribute :expires_at,  Types::Time
      attribute :scope,       Types::Array
      attribute :cancel_link, Types::String
      attribute :client,      Types::Class

    end

  end
end
