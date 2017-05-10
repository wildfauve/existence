require './lib/existence/domain/scope'

module Existence

  module Services

    class ScopesService < ServiceBase

      RESOURCE = "scopes"
      ACTION_LIST = "list"

      include Dry::Monads::Either::Mixin

      def initialize(scope: Domain::Scope)
        super
        @scope = scope
      end

      def call(policy_decision_point)
        # return Left(nil) if check_authorisation(decision_point: policy_decision_point, action: ACTION_LIST).left?
        Right(get_scopes).bind do |value|
          value.success? ? value : Left(nil)
        end
      end

      private

      def get_scopes()
        @scope.new.get_scopes()
      end

    end

  end

end
