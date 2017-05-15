module Existence

  module Domain

    class LinkValue < Dry::Struct
      attribute :rel,       Types::String
      attribute :href,      Types::String
    end

  end

end
