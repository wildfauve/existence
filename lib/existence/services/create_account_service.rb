require_relative 'service_base'
require_relative '../domain/account'

module Existence

  module Services

    class CreateAccountService < ServiceBase

      RESOURCE = "identity_account"
      ACTION_LIST = "create"

      include Dry::Monads::Either::Mixin

      def initialize(account: Domain::Account,
                     validations_factory: Existence::ValidationsFactory)
        super
        @account = account
        @validations_factory = validations_factory
      end

      def call(account_params:, authorising_token:, policy_decision_point: nil)
        return Left(nil) if !policy_decision_point.nil? && check_authorisation(decision_point: policy_decision_point, action: ACTION_LIST).left?
        Right(account: account_params, authorising_token: authorising_token, policy_decision_point: policy_decision_point).bind do |input|
          validate(account_params)
        end.bind do |validation|
          create_account(account_params: validation.output, authorising_token: authorising_token)
        end.bind do |result|
          Right(result)
        end.or do |error|
          Left(error)
        end
      end

      private

      def create_account(account_params:, authorising_token: )
        @account.new.create(account_params: account_params, authorising_token: authorising_token)
      end

      def validate(account_params)
        validation = account_validation.new.(params: account_params)
        validation.success? ? Right(validation) : Left(validation)
      end

      def account_validation
        @validations_factory.new.(:account).value
      end


    end

  end

end
