require 'ostruct'

module Existence

  class Config < OpenStruct ; end

  class Configuration

    class << self

      RESOURCES = { scopes: '/api/concepts/scopes' }

      def build(&block)
        block.call self
        set_resources
        self
      end

      def reset!
        @config = nil
      end

      def config
        @config ||= Existence::Config.new
      end

      def identity_host=(host)
        config.identity_host = host
      end

      def identity_host
        config.identity_host
      end

      def set_resources
        config.resources = RESOURCES
      end

      def resource_for(resource)
        config.resources[resource]
      end

    end # class << self

  end  # clas Configuration

end  # module ScoreCard
