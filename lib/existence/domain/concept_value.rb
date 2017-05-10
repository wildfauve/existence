module Existence

  module Domain

    class ConceptValue < Dry::Struct
      attribute :identity,            Types::String
      attribute :name,                Types::String
      attribute :description,         Types::String
    end

  end

end
