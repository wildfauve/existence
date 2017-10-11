require 'spec_helper'

describe "AuthorisationsService" do

  context "obtain the external authorisations" do

    let(:current_user) { double("UserProxy", jwt: "scoped_user_jwt", )}

    let(:system_user) { double("UserProxy", jwt: "system_user_jwt", )}


    let(:user_authz_internal_only) {
      {"kind"=>"user_authorisations",
       "authorizations"=>
        [{"kind"=>"authorisation",
          "created_at"=>"2016-12-01 11:17:23 +1300",
          "expires_at"=>"2017-01-30 11:17:23 +1300",
          "scope"=>[],
          "client"=>{"kind"=>"client", "name"=>"Developer", "type"=>"standard_client", "external_client"=>false, "account"=>{}},
          "links"=>[{"rel"=>"cancel", "href"=>"/api/user_authz/d9683368-64c0-45f1-a144-cb0c71b895e2"}]}]}
    }

    let(:user_authz_external_only) {
      {"kind"=>"user_authorisations",
       "authorizations"=>
        [{"kind"=>"authorisation",
          "created_at"=>"2016-12-01 11:17:23 +1300",
          "expires_at"=>"2017-01-30 11:17:23 +1300",
          "scope"=>[],
          "client"=>{"kind"=>"client", "name"=>"External_1", "type"=>"standard_client", "external_client"=>true, "account"=>{"name" => "External Totalitarian Corporate"}},
          "links"=>[{"rel"=>"cancel", "href"=>"/api/user_authz/d9683368-64c0-45f1-a144-cb0c71b895e2"}]}]}
    }

    let(:success_policy) { double("PolicyDecisionPoint", call: M.Right(true)) }

    let(:user_internal_port_resp) { M.Right(OpenStruct.new(body: user_authz_internal_only, status: :ok)) }

    let(:user_external_port_resp) { M.Right(OpenStruct.new(body: user_authz_external_only, status: :ok)) }

    let(:port_query_params) {
      {query_params: {scoping_user_token: current_user.jwt}, credentials: "Bearer system_user_jwt"}
    }


    it "should return an empty array of authorisations when only internal clients are involved with the user" do

      expect(Existence::Ports::IdentityPort).to receive_message_chain(:new, :get_from_port)
                                 .with(hash_including(port_query_params))
                                 .and_return(user_internal_port_resp)

      authz = Existence::Services::GetAuthorisationsService.new.(system_user, current_user, success_policy)

      expect(authz.right?).to be true
      expect(authz.value.empty?).to be true

    end

    it "should return external client authorisations" do

      expect(Existence::Ports::IdentityPort).to receive_message_chain(:new, :get_from_port)
                                 .with(hash_including(port_query_params))
                                 .and_return(user_external_port_resp)

      authz = Existence::Services::GetAuthorisationsService.new.(system_user,  current_user, success_policy)

      expect(authz.right?).to be true
      expect(authz.value.size).to eq 1
      expect(authz.value.first.client.name).to eq "External_1"

    end


  end # context


  context "Delete (or cancel) an authorisation" do

    let(:system_user) { double("UserProxy", jwt: "system_user_jwt", )}

    let(:cancel_link) { "/api/user_authz/d9683368-64c0-45f1-a144-cb0c71b895e2" }

    let(:success_policy) { double("PolicyDecisionPoint", call: M.Right(true)) }

    let(:port_params) { {credentials: "Bearer system_user_jwt", resource: cancel_link} }

    let(:port_resp) { M.Right(OpenStruct.new(body: nil, status: :ok)) }


    it "send the delete to the right link and on the system user's token" do

      expect(Existence::Ports::IdentityPort).to receive_message_chain(:new, :delete_to_port)
                                 .with(hash_including(port_params))
                                 .and_return(port_resp)

      cancel = Existence::Services::CancelAuthorisationsService.new.(cancel_link, system_user, success_policy)

      expect(cancel.right?).to be true
      expect(cancel.value).to be nil

    end

  end # context

end
