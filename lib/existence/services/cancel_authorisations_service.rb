require_relative 'service_base'
require_relative '../domain/authorisation'

module Existence

  module Services

    class CancelAuthorisationsService < ServiceBase

      RESOURCE = "authz"
      ACTION_CANCEL = "cancel"

      include Dry::Monads::Either::Mixin

      def initialize(authorisation: Domain::Authorisation)
        super
        @authorisation = authorisation
      end

      def call(link, system_user, policy_decision_point)
        return Left(nil) if !policy_decision_point.nil? && check_authorisation(decision_point: policy_decision_point, action: ACTION_CANCEL).left?
        Right(cancel_link: link, system_user: system_user).bind do |input|
          cancel_authorisations(input)
        end.bind do |result|
          Right(result)
        end.or do |error|
          Left(nil)
        end
      end

      private

      def cancel_authorisations(params)
        @authorisation.new.cancel_authorisations(params[:cancel_link], user_bearer(params[:system_user]))
      end


    end

  end

end
