module Existence

  module Domain

    class ServiceErrorValue < Dry::Struct

      attribute :code,        Types::String
      attribute :message,     Types::String
      attribute :attributes,  Types::Array
    end

  end

end
