module Existence
  module Domain

    class UserInfoValue < Dry::Struct

      attribute :sub,                 Types::String
      attribute :preferred_name,      Types::String
      attribute :username,  Types::String
      attribute :allowed_activities,  Types::Array
      attribute :context_assertions,  Types::Class
      attribute :refresh_token,       Types::String
      attribute :access_token,        Types::String
      attribute :jwt,                 Types::String
      attribute :expires_at,          Types::String
      attribute :system_user,         Types::Bool

    end

  end

end
