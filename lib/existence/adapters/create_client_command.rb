require_relative 'adapter_base'

module Existence

  module Adapters

    class CreateClientCommand < AdapterBase

      def initialize(config: Configuration)
        super
      end

      def call(params: , jwt:)
        result(send_to_port(params, jwt))
      end

      private

      def send_to_port(params, jwt)
        return Right(OpenStruct.new(body: mock_create_acct_value, status: :ok)) if @config.mock
        port.new.send_on_port(params: params,
                              credentials: bearer_token(jwt),
                              service: service,
                              resource: params[:oauth_clients_link],
                              encoding: :json )
      end

      def mock_create_client_value
        {
          "@type"=>"oauth_client",
          "id"=>"36803706-6111-429f-95b3-0e3d34efca73",
          "name"=>"app1",
          "client_id"=>"1b3b6hb4rxw0uhnsum90zg2r2ixl92d2bkxxzluvefxqrv8wmx",
          "client_secret"=>"84hbpxn9sqkzs173qmtum12mc3j27bxhlll5dxzu35mn1khnh",
          "links"=>
          [{"rel"=>"self", "href"=>"/api/oauth_clients/36803706-6111-429f-95b3-0e3d34efca73"},
           {"rel"=>"client_account", "href"=>"/api/client_accounts/23f34d9a-8d33-440a-b271-8f5a9d1553c4"}]
         }
      end


    end

  end

end
