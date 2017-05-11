require 'spec_helper'

describe Existence::Services::GetUserInfoService do

  context "userinfo from token" do
    let(:user_info_claims) {
      {
         "sub"=>"af75c3b7-21a3-4fd1-ac85-2180f754166c",
         "email"=>nil,
         "email_verified"=>true,
         "preferred_name"=>"Test1+User",
         "preferred_username"=>"test1",
         "updated_at"=>"2016-11-29T16:04:21+13:00",
         "allowed_activities"=>[
            "lic:animal_timeline:resource:*:*",
            "lic:place:resource:*:*",
            "lic:pasture_measurement:resource:*:*",
            "lic:pasture_measurement:resource:measurement:view",
            "lic:developer:resource:authn:list"
         ],
         "context_assertions"=>
          [
            {"type"=>"identifier_assertion",
            "identifier_kind"=>"urn:lic:ids:animal_group_bp",
            "identifier"=>"5003949",
            "activity"=>"lic:animal_timeline:resource:timeline:create"},
           {"type"=>"identifier_assertion",
            "identifier_kind"=>"urn:lic:ids:animal_group_bp",
            "identifier"=>"5003949",
            "activity"=>"lic:animal_timeline:resource:timeline:update"},
           {"type"=>"identifier_assertion",
            "identifier_kind"=>"urn:lic:ids:animal_group_bp",
            "identifier"=>"5000000",
            "activity"=>"lic:animal_timeline:resource:timeline:show"},
           {"type"=>"identifier_assertion",
            "identifier_kind"=>"urn:lic:ids:farm",
            "identifier"=>"-1",
            "activity"=>"lic:places:resource:place:create"},
           {"type"=>"identifier_assertion",
            "identifier_kind"=>"urn:lic:ids:farm",
            "identifier"=>"-2",
            "activity"=>"lic:places:resource:place:create"},
           {"type"=>"identifier_assertion",
            "identifier_kind"=>"urn:lic:ids:farm",
            "identifier"=>"-1",
            "activity"=>"lic:places:resource:place:update"},
           {"type"=>"identifier_assertion",
            "identifier_kind"=>"urn:lic:ids:farm",
            "identifier"=>"-2",
            "activity"=>"lic:places:resource:place:update"},
           {"type"=>"identifier_assertion",
            "identifier_kind"=>"urn:lic:ids:farm",
            "identifier"=>"-1",
            "activity"=>"lic:places:resource:place:show"},
           {"type"=>"identifier_assertion",
            "identifier_kind"=>"urn:lic:ids:farm",
            "identifier"=>"-2",
            "activity"=>"lic:places:resource:place:show"}
          ]
        }
      }

    let(:userinfo_port_resp) { M.Right(OpenStruct.new(body: user_info_claims, status: :ok)) }

    let(:token_value) { double(Existence::Domain::IdentityTokenValue,
                                    jwt: "Fake_JWT",
                                    refresh_token: "fake refresh",
                                    access_token: "fake access_token",
                                    expires_at: Time.now,
                                     ) }

    it "should get userinfo" do
      allow(Existence::Ports::IdentityPort).to receive_message_chain(:new, :get_from_port).and_return(userinfo_port_resp)

      token = Existence::Services::GetUserInfoService.new.(token_value)

    end

  end

end
