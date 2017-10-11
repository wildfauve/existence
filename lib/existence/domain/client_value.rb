module Existence

  module Domain

    class ClientValue < Dry::Struct

      attribute :type,            Types::String
      attribute :id,              Types::String
      attribute :name,            Types::String
      attribute :client_id,       Types::String
      attribute :client_secret,   Types::String.optional
      attribute :redirect_uri,    Types::Uri.optional
      attribute :logout_endpoint, Types::Uri.optional
      attribute :links,           Types::Array

    end

  end

end
