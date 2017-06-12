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
        "id" => "a1",
        "name" => "new account",
        "state" => "prospect",
        "links" => [
          {"rel"=>"self", "href"=>"/api/client_accounts/a1"},
          {"rel"=>"oauth_clients_feed", "href"=>"/api/client_accounts/a1/oauth_clients"}
        ]
      }
    }

    let(:clients) {
      {
        "@type" => "oauth_clients_feed",
        "oauth_clients" => [
          {
            "@type" => "oauth_client",
            "id" => "/api/client_accounts/a1/oauth_clients/1",
            "name" => "Client 1"
          },
          {
            "@type" => "oauth_client",
            "id" => "/api/client_accounts/a1/oauth_clients/2",
            "name" => "Client 2"
          }
        ],
        "links": [
          {
            "rel": "self",
            "href": "/api/client_accounts/a1/oauth_clients"
          },
          {
            "rel": "client_account",
            "href": "/api/client_accounts/a1"
          }
        ]
      }
    }

    let(:get_account_port_resp) { M.Right(OpenStruct.new(body: account, status: :ok)) }

    let(:client_feed) { M.Right(clients) }

    it 'should get the account and the clients' do

      allow(Existence::Ports::IdentityPort).to receive_message_chain(:new, :get_from_port).and_return(get_account_port_resp)

      allow(Existence::Adapters::GetClientFeedCommand).to receive_message_chain(:new, :call)
                                                      .and_return(client_feed)

      acct = Existence::Services::GetAccountService.new.find(id: "/api/client_accounts/1",
                                                             scoping_user_token: "user",
                                                             authorising_token: "system")
      expect(acct).to be_success
      expect(acct.value.clients.map(&:name)).to include('Client 1', 'Client 2')

    end


  end

end
