module Existence

  module Validations

    class AccountValidator

      attr_reader :schema

      AccountValidatorSchema = Dry::Validation.Schema do

        configure do
          predicates(Existence::ValidationPredicates)

          def self.messages
            super.merge(
                        en: { errors:
                              {
                                urn?: 'The URN is invalid'
                              }
                            }
                        )
          end

        end


         required(:name) { str?  }
         required(:allowed_scopes).each { urn? }
         required(:why) { str? }
         optional(:scoping_user_token).maybe { str? }
       end

     attr_reader :validation_schema

     def call(params:, schema: AccountValidatorSchema)
       schema.(params)
     end
   end
 end
end
