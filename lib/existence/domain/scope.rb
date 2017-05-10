require './lib/existence/domain/concept_value'
require './lib/existence/adapters/get_scopes_command'

module Existence

  module Domain

    class Scope

      include Dry::Monads::Either::Mixin

      def initialize(concept_value: Domain::ConceptValue,
                     get_scopes_command_adapter: Adapters::GetScopesCommand)
        @concept_value = concept_value
        @get_scopes_command_adapter = get_scopes_command_adapter
      end

      def get_scopes
        Right(nil).bind do |input|
          perform_get_scopes
        end.bind do |result|
          Right(concept_value(result))
        end
      end

      private

      def perform_get_scopes
        @get_scopes_command_adapter.new.()
      end

      def concept_value(result)
        result["concepts"].map do |concept|
          @concept_value.new(identity: concept["identity"],
                             name: concept["name"],
                             description: concept["description"])
        end
      end

    end

  end

end
