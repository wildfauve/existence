module Existence

  module Domain

    class ClientValue < Dry::Struct

      attribute :name,            Types::String
      attribute :type,            Types::String
      attribute :external_client, Types::Bool
      attribute :account_name,    Types::String

    end

  end

end
