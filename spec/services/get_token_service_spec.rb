require 'spec_helper'

describe Existence::Services::GetTokenService do

  context "authorisation code grant token" do

    let(:fake_code) { "fake_code" }
    let(:redirect_uri) { "/redirect_uri" }
    let(:oauth_grant_type) { :auth_code_grant_params }

    let(:token) {
      {
        "token_type" => "Bearer",
        "access_token" => "4yemfk9tje3tu5bhjbfnwzkxg1enyc",
        "id_token" => "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJpZGVudGl0eS5taW5kYWluZm8uaW8iLCJzdWIiOiJlZTNmYmQzZC1hNGVjLTRiZWQtOGNmZi0xODRlZjUzM2UzZGMiLCJhdWQiOiJlYzdkYzU0ZS0yOTgyLTQ3YzUtYmMwOS1iZTBhYzJlODJhMzAiLCJleHAiOjE0OTk4MDY2MzksImFtciI6W10sImlhdCI6MTQ5NDUzNjIzOSwiYXpwIjoiZWM3ZGM1NGUtMjk4Mi00N2M1LWJjMDktYmUwYWMyZTgyYTMwIn0.ol9Viz5wgdz6YvgAIn-LxWYxKGwTOBZLmK0U9sPk5hfMVKK-YwOOma_J3SfLtsxqbRrvVCyxK7UuRKo9mRCfpxBR9A790kbbvzs-8obqcfQ944DADwLc1VgL2B9z-7TmJqM56nh0vFD5M72aLWFgzuZKpUkF2okgKcaeTNAunVVSCm4CZutgBQ9hVjT4qkWuzOFoOYDjDbTApxaNo3SG40t_HAEU1zneY9WM8diNm1Q2uZwdE71G_jFwjnbtEAcrEiDTOXFRLyFptLUZ_IDVmomBnmNdoqw2WYEzDWz5jB0nzhYdV7Yv1-N1SIxk0IbxmFToRk7nQydLP9SOnT3CaQ",
        "expires_in" => "5183998"
      }
    }

    let(:token_port_resp) { M.Right(OpenStruct.new(body: token, status: :ok)) }


    it "get auth code token" do
      allow(Existence::Ports::IdentityPort).to receive_message_chain(:new, :send_on_port).and_return(token_port_resp)

      token = Existence::Services::GetTokenService.new.(fake_code, redirect_uri, oauth_grant_type)

      expect(token).to be_success

    end

  end # context

  context "client credentials grant" do

    let(:system_user_jwt) { "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJpZGVudGl0eS5taW5kYWluZm8uaW8iLCJzdWIiOiJhYzlkNGJjNC01MGMwLTRjZTEtYjdkYy0xZTBlYTY2ZTFmYjQiLCJhdWQiOiJlYzdkYzU0ZS0yOTgyLTQ3YzUtYmMwOS1iZTBhYzJlODJhMzAiLCJleHAiOjE0OTk4MTcyNTUsImFtciI6W10sImlhdCI6MTQ5NDU0Njg1NSwiYXpwIjoiZWM3ZGM1NGUtMjk4Mi00N2M1LWJjMDktYmUwYWMyZTgyYTMwIn0.VUCukL3Un6EOdjJOh4rTHHnm15Prbx5rkj4CuOPx2HGRXxMO0z16lBkf_PFGBJP0u04GGjUdN-Gmui1rec7ghYm4qYe8toPtA6yZafSKFueoVhFfgbbk7p5aWe-RxFvtpEnGDft1RCmXPLra3_bQMsAS-nlJ2vPXsyWVD9_jaUdJmgTqoAASj-mtRAkwKKsEqWQtrr-xQbk1SoT2sfUyRYcCwI4BgCLGnriJ7fazQ6g_uVSU1Jw1XbbmJlieqgdk_ob7foK6iuiT1LcgCFO8ZQblhCMLXcWkUamP2xLlwt90x-fmgzZjirRED9aXmVCFPtmRiOAEU07ESEhEuTxflw" }

    let(:oauth_grant_type) { :client_credentials_grant_params }

    let(:jwt_exp) {1486433600}

    let(:system_token) {
      {"token_type"=>"Bearer",
            "access_token"=>"qc7667uqnk2do5i1zhym8zkjgheclpp",
            "id_token"=> system_user_jwt,
            "expires_in"=>5356800}
    }

    let(:token_port_resp) { M.Right(OpenStruct.new(body: system_token, status: :ok)) }

    let(:system_user_info_claims) {
      {
         "sub"=>"system_1",
         "email"=>nil,
         "email_verified"=>true,
         "preferred_name"=>"system_user@mindinfo.io",
         "preferred_username"=>"system_user@mindinfo.io",
         "updated_at"=>"2016-11-29T16:04:21+13:00",
         "allowed_activities"=>[
            "lic:animal_timeline:resource:*:*",
            "lic:place:resource:*:*",
            "lic:pasture_measurement:resource:*:*",
            "lic:pasture_measurement:resource:measurement:view",
            "lic:developer:resource:authn:list"
         ],
         "context_assertions"=>[]
        }
      }

    let(:user_info_port_resp) { M.Right(OpenStruct.new(body: system_user_info_claims, status: :ok)) }

    it 'should be a valid system client' do
      allow(Existence::Ports::IdentityPort).to receive_message_chain(:new, :send_on_port).and_return(token_port_resp)

      token = Existence::Services::GetTokenService.new.(nil, nil, oauth_grant_type)
      expect(token).to be_success

    end

  end #context

end
