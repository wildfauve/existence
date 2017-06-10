require 'spec_helper'

describe Existence::Services::GetAccountService do

  context 'get accounts' do

    let(:accounts) { {
                      "@type" => "client_accounts_feed",
                      "accounts" => [
                        {
                          "@type" => "client_account",
                          "id"=>"/api/client_accounts/1",
                          "name"=>"An Account",
                          "state"=>"prospect"
                        },
                        {
                          "@type" => "client_account",
                          "id"=>"/api/client_accounts/1",
                          "name"=>"Another Account",
                          "state"=>"prospect"
                        }
                      ],
                      "links" => [{"rel"=>"self", "href"=>"/api/client_accounts"}]
                    }
                  }
      let(:get_accounts_port_resp) { M.Right(OpenStruct.new(body: accounts, status: :ok)) }

    it 'should get accounts based on a scoped user' do

      allow(Existence::Ports::IdentityPort).to receive_message_chain(:new, :get_from_port).and_return(get_accounts_port_resp)

      accts = Existence::Services::GetAccountService.new.(scoping_user_token: "user", authorising_token: "system" )

      link = Existence::Domain::LinkValue.new(rel: "client_account", href: "api/client_accounts/1")
      value = Existence::Domain::AccountValue.new(type:"client_account",
                                                  id: "api/client_accounts/1",
                                                  name: "An Account",
                                                  state: "prospect",
                                                  links: [link])

      expect(accts).to be_success
      expect(accts.value.count).to eq 2
      acct = accts.value.first
      expect(acct).to be_instance_of Existence::Domain::Account
      expect(acct.id).to eq "api/client_accounts/1"
      expect(acct.links.size).to eq 1
      expect(acct.links.first.href).to eq "api/client_accounts/1"
    end

  end  # context accounts

  context 'get account' do

    let(:account) {
      {
        "@type" => "client_account",
        "id" => "1",
        "name" => "new account",
        "state" => "prospect",
        "links" => [
          {"rel"=>"self", "href"=>"/api/client_accounts/8e808527-04d1-4176-9802-89a482c03c2b"},
          {"rel"=>"oauth_clients_feed", "href"=>"/api/client_accounts/8e808527-04d1-4176-9802-89a482c03c2b/oauth_clients"}
        ]
      }
    }

    let(:get_account_port_resp) { M.Right(OpenStruct.new(body: account, status: :ok)) }

    it 'should get the account' do

      allow(Existence::Ports::IdentityPort).to receive_message_chain(:new, :get_from_port).and_return(get_account_port_resp)

      acct = Existence::Services::GetAccountService.new.find(id: "/api/client_accounts/1",
                                                             scoping_user_token: "user",
                                                             authorising_token: "system")
      binding.pry

    end


  end

end
