module Existence

  module Domain

    class MonadPolicyEnforcer

      include Dry::Monads::Either::Mixin

      def call(args)
        Right(args).bind do |value|
          if args[:policy_decision]
            Right(nil)
          else
            Rails.logger.info("Policy decision failed; resource:#{args[:resource]}; action: #{args[:action]}")
            Left(nil)
          end
        end
      end

    end

  end
end
