require_relative 'service_base'
require_relative '../domain/authorisation'

module Existence

  module Services

    class GetAuthorisationsService < ServiceBase

      RESOURCE = "authz"
      ACTION_LIST = "list"

      include Dry::Monads::Either::Mixin

      def initialize(authorisation: Domain::Authorisation)
        super
        @authorisation = authorisation
      end

      def call(system_user, user, policy_decision_point)
        return Left(nil) if !policy_decision_point.nil? && check_authorisation(decision_point: policy_decision_point, action: ACTION_LIST).left?
        Right(system_user: system_user, user: user, policy_decision_point: policy_decision_point).bind do |input|
          get_authorisations(input)
        end.bind do |result|
          Right(result)
        end.or do |error|
          Left(nil)
        end
      end

      private

      def get_authorisations(params)
        @authorisation.new.get_authorisations({scoping_user_token: params[:user].jwt}, user_bearer(params[:system_user]))
      end

    end

  end

end
