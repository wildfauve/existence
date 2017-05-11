require 'spec_helper'

describe Existence::Services::ScopesService do

  context "get scopes" do

    scopes = {
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

    let(:scope_port_resp) { M.Right(OpenStruct.new(body: scopes, status: :ok)) }

    it 'should retrieve scopes' do
      allow(Existence::Ports::IdentityPort).to receive_message_chain(:new, :get_from_port).and_return(scope_port_resp)

      scopes = Existence::Services::ScopesService.new.(nil)
      expect(scopes).to be_success
      expect(scopes.value.size).to eq 3

    end

  end
end
