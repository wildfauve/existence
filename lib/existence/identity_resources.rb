module Existence

  class IdentityResources

    def self.resource_for(resource)
      Configuration.config.resources.send(resource)
    end

    def self.endpoint_for(resource)
      Configuration.config.identity_host + resource_for(resource)
    end

  end

end
