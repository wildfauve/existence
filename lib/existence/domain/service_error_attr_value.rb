module Existence

  module Domain

    class ServiceErrorAttrValue < Dry::Struct

      attribute :attribute,        Types::String
      attribute :message,          Types::Array
    end

  end

end
