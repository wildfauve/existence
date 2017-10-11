require_relative '../domain/user_info'

module Existence

  module Services

    class GetUserInfoService < ServiceBase

      include Dry::Monads::Either::Mixin

      def initialize(user_info: Domain::UserInfo)
        super
        @user_info = user_info
      end

      def call(token_value)
        # TODO: validation and error object
        Right(token_value).bind do |token_value|
          get_user(token_value)
        end.bind do |result|
          Right(result)
        end.or do |error|
          Left(nil)
        end
      end

      private

      def get_user(token_value)
        @user_info.new.(token_value)
      end

    end

  end

end
