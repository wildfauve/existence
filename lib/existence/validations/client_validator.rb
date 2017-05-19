module Existence

  module Validations

    class ClientValidator

      attr_reader :schema

      ClientValidatorSchema = Dry::Validation.Schema do

        configure do
          predicates(ValidationPredicates)

          def self.messages
            super.merge(
                        en: { errors:
                              {
                                uri?: 'The URL is invalid'
                              }
                            }
                        )
          end

        end


        required(:name) { str? }
        required(:redirect_uri) { uri? }
        optional(:logout_endpoint) { uri? }
        required(:account_link) { url_path?}
        # optional(:logout_endpoint) { format?(/^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/) }

      end

      attr_reader :schema

      def call(params:)
        schema = ClientValidatorSchema
        schema.(params)
      end

    end

  end

end
