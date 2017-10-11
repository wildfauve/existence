module Existence

  class Configuration

    extend Dry::Configurable

    setting :resources do
      setting :home, '/api'
      setting :scopes, '/api/concepts/scopes'
      setting :authz, '/api/user_authz'
      setting :userinfo, '/userinfo'
      setting :token, '/oauth/token'
      setting :logout, '/logout'
      setting :authorise, '/oauth/authorize'
      setting :accounts, '/api/client_accounts'
      setting :oauth_clients, '/api/oauth_clients'
    end

    setting :rels do
      setting :oauth_clients_feed, "oauth_clients_feed"
      setting :client_account, "client_account"
    end

    setting :identity_host

    setting :client_id

    setting :client_secret

    setting :identity_public_key

    setting :identity_private_key

    setting :service_name

    setting :mock

  end  # class Configuration

end  # module ScoreCard
