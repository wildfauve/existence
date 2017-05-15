require 'ostruct'

module Existence

  class Config < OpenStruct ; end

  class Configuration

    class << self

      RESOURCES = { scopes: '/api/concepts/scopes',
                    authz: '/api/user_authz',
                    userinfo: '/userinfo',
                    token: '/oauth/token',
                    logout: '/logout',
                    authorise: '/oauth/authorize',
                    accounts: '/api/client_accounts'}

      def build
        yield config
        set_resources
        self
      end

      def config
        @config ||= Existence::Config.new
      end

      def set_resources
        config.resources = RESOURCES
      end

      def resource_for(resource)
        config.resources[resource]
      end

      def endpoint_for(resource)
        config.identity_host + resource_for(resource)
      end

      # def set_resources
      #   RESOURCES.map { |n,v| config.send("#{n}=".to_sym, v)}
      # end


    end # class << self

  end  # clas Configuration

end  # module ScoreCard
