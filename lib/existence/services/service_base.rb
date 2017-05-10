require './lib/existence/policy/monad_policy_enforcer'

module Existence

  module Services

    class ServiceBase

      def initialize(monad_enforcer: Domain::MonadPolicyEnforcer, **)
        @monad_enforcer = monad_enforcer
      end

      def user_bearer(user)
        user.jwt
      end

      def check_authorisation(decision_point: ,action:)
        decision_point.(resource: self.class::RESOURCE, action: action, enforcer: @monad_enforcer.new)
      end

    end

  end

end
