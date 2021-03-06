require_relative 'service_base'
require_relative '../domain/accounts_feed'

module Existence

  module Services

    class GetAccountService < ServiceBase

      RESOURCE = "identity_account"
      ACTION_LIST = "list"

      include Dry::Monads::Either::Mixin

      def initialize(account_feed: Domain::AccountsFeed,
                     account: Domain::Account)
        super
        @account_feed = account_feed
        @account = account
      end

      def call(scoping_user_token:, authorising_token:, policy_decision_point: nil)
        return Left(nil) if !policy_decision_point.nil? && check_authorisation(decision_point: policy_decision_point, action: ACTION_LIST).left?
        Right(nil).bind do |input|
          get_accounts_feed(scoping_user_token: scoping_user_token, authorising_token: authorising_token)
        end.bind do |result|
          Right(result)
        end.or do |error|
          Left(error)
        end
      end

      def find(id:, scoping_user_token:, authorising_token:, policy_decision_point: nil)
        return Left(nil) if !policy_decision_point.nil? && check_authorisation(decision_point: policy_decision_point, action: ACTION_LIST).left?
        Right(nil).bind do |input|
          get_account(id: id, scoping_user_token: scoping_user_token, authorising_token: authorising_token)
        end.bind do |result|
          Right(result)
        end.or do |error|
          Left(error)
        end
      end

      private

      def get_accounts_feed(scoping_user_token:, authorising_token: )
        @account_feed.new.feed(scoping_user_token: scoping_user_token, authorising_token: authorising_token)
      end

      def get_account(id:, scoping_user_token:, authorising_token: )
        @account.find(id: id, scoping_user_token: scoping_user_token, authorising_token: authorising_token)
      end

    end

  end

end
