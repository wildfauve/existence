module Existence

  module Domain

    class AccountValue < Dry::Struct
      attribute :type,        Types::String
      attribute :id,          Types::String
      attribute :name,        Types::String
      attribute :state,       Types::String
      attribute :links,       Types::Array
    end

  end
end
