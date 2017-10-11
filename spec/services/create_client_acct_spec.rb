require 'spec_helper'

describe Existence::Services::CreateAccountService do

  context 'create account' do

    let(:account) { {
                      name: "Test Acct",
                      scoping_user_token: "fake_jwt",
                      allowed_scopes: ["urn:id:scope:farm_perf", "urn:id:scope:basic_profile"],
                      why: "because"
                    }
                  }

    let(:acct_resp) { {
                      "@type" => "client_account",
                      "id" => "8e787204-328c-49d6-8f51-4175f5f86ebf",
                      "name" => "Test Account",
                      "state" => "prospect",
                      "links" => [{"rel"=>"self", "href"=>"/api/client_accounts/8e787204-328c-49d6-8f51-4175f5f86ebf"}]
                      }
                    }
    let(:create_account_port_resp) { M.Right(OpenStruct.new(body: acct_resp, status: :ok)) }

    it 'should create an account' do

      allow(Existence::Ports::IdentityPort).to receive_message_chain(:new, :send_on_port).and_return(create_account_port_resp)

      acct = Existence::Services::CreateAccountService.new.(account_params: account,
                                                             authorising_token: "fake_system_token")


      expect(acct).to be_success
      expect(acct.value).to be_instance_of Existence::Domain::AccountValue

    end

  end

end
