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
        "id_token" => "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJpZGVudGl0eS5taW5kYWluZm8uaW8iLCJzdWIiOiJhYzlkNGJjNC01MGMwLTRjZTEtYjdkYy0xZTBlYTY2ZTFmYjQiLCJhdWQiOiJlYzdkYzU0ZS0yOTgyLTQ3YzUtYmMwOS1iZTBhYzJlODJhMzAiLCJleHAiOjE0OTkxMTE4OTYsImFtciI6W10sImlhdCI6MTQ5Mzg0MTQ5NiwiYXpwIjoiZWM3ZGM1NGUtMjk4Mi00N2M1LWJjMDktYmUwYWMyZTgyYTMwIn0.NivJxn5nUSIw6FE6Y_ysFfkU7LNKl2cEE3SQU8G-0oCBbVQnWbg26bTtlZ9_2K1k3lofvVehSBC3NgmCdEBn9b6Ap1QPmR26ccr9BfboxZ_6nAJRWo0PR-Enan8QPAYn-nyqEa_9yKeWHE7TVD_dgk-soHQT_lfM_-0IhqxA-qGlpq1yCCxQkEuM0Tkf5rEokkmLNAZE82Eikf3_brJW99AvoJw8cVWQlCsKM654QQMZw56_ou2E4L_v70iMZdi2Dk9KawaLcJDqJdLr3LXF6b_lEUu9gkjaz-OMDUWNQQqd_hdB-N4WXFJ1QXPbzXOc1XFWMuTdjok_7jBRYKWaEQ",
        "expires_in" => "5183998"
      }
    }

    let(:token_port_resp) { M.Right(OpenStruct.new(body: token, status: :ok)) }


    it "get auth code token" do
      allow(Existence::Ports::IdentityPort).to receive_message_chain(:new, :send_on_port).and_return(token_port_resp)

      token = Existence::Services::GetTokenService.new.(fake_code, redirect_uri, oauth_grant_type)

    end

  end

end
