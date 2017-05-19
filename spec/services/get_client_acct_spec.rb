require 'spec_helper'

describe Existence::Services::GetAccountService do

  context 'get accounts' do

    let(:accounts) { {
                      "@type" => "client_accounts_feed",
                      "accounts" => [
                        {
                          "@type" => "client_account",
                          "id"=>"api/client_accounts/1",
                          "name"=>"An Account",
                          "state"=>"prospect"
                        },
                        {
                          "@type" => "client_account",
                          "id"=>"api/client_accounts/1",
                          "name"=>"Another Account",
                          "state"=>"prospect"
                        }
                      ],
                      "links" => [{"rel"=>"self", "href"=>"/api/client_accounts"}]
                    }
                  }
      let(:get_account_port_resp) { M.Right(OpenStruct.new(body: accounts, status: :ok)) }

    it 'should get accounts based on a scoped user' do

      allow(Existence::Ports::IdentityPort).to receive_message_chain(:new, :get_from_port).and_return(get_account_port_resp)

      accts = Existence::Services::GetAccountService.new.(scoping_user_token: "user", authorising_token: "system" )

      value = Existence::Domain::AccountValue.new(type:"client_account",
                                                  id: "api/client_accounts/1",
                                                  name: "An Account",
                                                  state: "prospect",
                                                  links: [])

      expect(accts).to be_success
      expect(accts.value.count).to eq 2
      expect(accts.value.first).to be_instance_of Existence::Domain::AccountValue
      expect(accts.value).to include(value)
    end

  end

end
