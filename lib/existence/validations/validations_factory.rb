require_relative 'account_validator'

module Existence

  class ValidationsFactory

    include Dry::Monads::Either::Mixin

    VALIDATIONS = {
      account: Validations::AccountValidator
    }

    def initialize()
    end

    def call(type)
      Right(type).bind do |type|
        valid_type(type)
      end.bind do |type|
        Right(VALIDATIONS[type])
      end.or do |error|
        Left(error)
      end
    end

    private

    def valid_type(type)
      VALIDATIONS.keys.include?(type) ? Right(type) : Left(type)
    end



  end

end
