require 'spec_helper'


describe Existence::Services::CreateOauthClientService do

  context 'create client' do

    let(:authorising_token) { "fake system jwt" }

    let(:create_client_params) {
                                  {
                                    name:             "New Client",
                                    redirect_uri:     "https://example.com/redirect",
                                    logout_endpoint:  "https://example.com/logout",
                                    client_type:      "standard_client",
                                    account_link:     "/api/client_accounts/1"
                                  }
                                }

    it 'should create a client associated with an account' do

      client = Existence::Services::CreateOauthClientService.new.(client_params: create_client_params,
                                                                  authorising_token: authorising_token,
                                                                  policy_decision_point: nil)
      expect(client).to be_success
      
    end

  end

end
