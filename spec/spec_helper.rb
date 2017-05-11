require 'bundler/setup'
require 'existence'
require 'pry'

require 'dry-monads'

M = Dry::Monads

Existence::Configuration.build do |config|
  config.identity_host = "http://localhost:5000"
  config.client_id = "client_id"
  config.client_secret = "client_secret"
  config.identity_public_key = OpenSSL::PKey::RSA.new("-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAt8ZBvBthpP8HJjgVCodE\n8ODG9WM1Fqq7mo+F8wZlHu7+HN/Y2vIS4pS+3kZ8mohQnQNtyNTyV+JsfHm2zOMv\nu92/Xo9BPjHvLcM7Ufcaz2/qokRTaCQrgSTYutfZ2wu34/hU8D90CtL0owKHBEDW\nbvlEPK92qz5/aw6BMwEh6/HKPvWoLY9U1vZVRHuDjlaCJQ/sF4v6qsVP8vIJvFrX\nEvkfqF64wd31Lv8YLrk40CSrNb0NHzSm/IbznN4cr7vDLat/ypGrsS8DNRTjqPPq\nzgiw2WOE2ecH2k9bRDJukdiH9oxgitgOotw4X4rsGeEnmDotEAEKrCDxR/KbuiAz\nEwIDAQAB\n-----END PUBLIC KEY-----\n")
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
