require "existence/version"

require 'dry-types'
require 'dry-monads'
require 'dry-struct'
require 'discourse'

module Types
  include Dry::Types.module
end


module Existence

  require 'existence/configuration'
  require 'existence/services/service_base'
  require 'existence/services/scopes_service'
  # Your code goes here...
end
