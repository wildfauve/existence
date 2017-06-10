require 'existence/version'
require 'dry-types'
require 'dry-monads'
require 'dry-struct'
require 'dry-validation'
require 'discourse'
require 'lic_auth'

module Types
  include Dry::Types.module
end


module Existence

  require 'existence/identity_resources'
  require 'existence/configuration'
  require 'existence/validations/predicates'
  require 'existence/services/service_base'
  require 'existence/services/scopes_service'
  require 'existence/services/get_authorisations_service'
  require 'existence/services/cancel_authorisations_service'
  require 'existence/services/get_token_service'
  require 'existence/services/get_userinfo_service'
  require 'existence/services/create_account_service'
  require 'existence/services/get_account_service'
  require 'existence/services/create_oauth_client_service'
  require 'existence/validations/validations_factory'


  # Your code goes here...
end
