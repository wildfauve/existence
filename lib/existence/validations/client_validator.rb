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
        required(:oauth_clients_link) { url_path?}
        required(:client_type).value(included_in?: ["standard_client", "native_client"])
        required(:handle) {format?(/^[\S]+$/) }

      end

      attr_reader :schema

      def call(params:)
        schema = ClientValidatorSchema
        schema.(params)
      end

    end

  end

end
