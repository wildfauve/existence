require_relative 'concept_value'
require_relative '../adapters/get_scopes_command'
require_relative 'domain_base'

module Existence

  module Domain

    class Scope < DomainBase

      include Dry::Monads::Either::Mixin

      def initialize(concept_value: Domain::ConceptValue,
                     get_scopes_command_adapter: Adapters::GetScopesCommand)
        super
        @get_scopes_command_adapter = get_scopes_command_adapter
        @concept_value = concept_value
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
        return Right(mock_value) if @config.mock
        @get_scopes_command_adapter.new.()
      end

      def concept_value(result)
        result["concepts"].map do |concept|
          @concept_value.new(identity: concept["identity"],
                             name: concept["name"],
                             description: concept["description"])
        end
      end

      def mock_value
        {
          "@type" => "concepts",
          "concept" => "urn:concepts:oauth_scopes",
          "concepts" => [
            {
              "identity" => "urn:id:scope:none",
              "name" => "none",
              "description" => ""
            },
            {
              "identity" => "urn:id:scope:farm_perf",
              "name" => "farm_perf",
              "description" => "Basic contact information; name and email, Pasture measurements (growth and cover) for authorised locations"
            },
            {
              "identity" => "urn:id:scope:basic_profile",
              "name" => "basic_profile",
              "description" => "Basic contact information; name and email"
            }
          ],
          "links" => [
            {
              "rel" => "self",
              "href" => "/api/concepts/scopes"
            },
            {
              "rel" => "up",
              "href" => "/api/concepts"
            }
          ]
        }
      end


    end

  end

end
