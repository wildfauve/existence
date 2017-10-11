module Existence
  module Domain

    class ContextAssertionValue < Dry::Struct

      attribute :activity, Types::String
      attribute :id, Types::String
      attribute :id_type, Types::String

    end

  end
end
