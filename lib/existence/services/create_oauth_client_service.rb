require_relative 'service_base'
require_relative '../domain/client'


module Existence

  module Services

    class CreateOauthClientService < ServiceBase

      RESOURCE = "identity_client"
      ACTION_LIST = "create"

      include Dry::Monads::Either::Mixin

      def initialize(client: Domain::Client,
                     validations_factory: Existence::ValidationsFactory)
        super
        @client = client
        @validations_factory = validations_factory
      end

      def call(client_params:, authorising_token:, policy_decision_point: nil)
        return Left(nil) if !policy_decision_point.nil? && check_authorisation(decision_point: policy_decision_point, action: ACTION_LIST).left?
        Right(client_params: client_params, authorising_token: authorising_token, policy_decision_point: policy_decision_point).bind do |input|
          validate(client_params)
        end.bind do |validation|
          create_client(client_params: validation.output, authorising_token: authorising_token)
        end.bind do |result|
          Right(result)
        end.or do |error|
          Left(error)
        end
      end

      private

      def create_client(client_params:, authorising_token: )
        @client.new.create(client_params: client_params, authorising_token: authorising_token)
      end

      def validate(client_params)
        validation = client_validation.new.(params: client_params)
        validation.success? ? Right(validation) : Left(validation)
      end

      def client_validation
        @validations_factory.new.(:client).value
      end


    end

  end

end
