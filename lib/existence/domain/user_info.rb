require_relative '../adapters/get_userinfo_command'
require_relative 'user_info_value'
require_relative 'context_assertions_value'

module Existence

  module Domain

    class UserInfo

      include Dry::Monads::Either::Mixin

      SYSTEM_USER = "system_user"

      attr_reader :adapter

      def initialize(adapter: Adapters::GetUserInfoCommand,
                     user_info_value: Domain::UserInfoValue,
                     context_assertions_value: Domain::ContextAssertionValue,
                     config: Configuration)
        @adapter = adapter
        @user_info_value = user_info_value
        @context_assertions_value = context_assertions_value
        @config = config
      end


      def call(token)
        Right(token).bind do |token|
          get_user_info(token)
        end.bind do |userinfo|
          Right(userinfo_value(userinfo, token))
        end.or do |error|
          Left(nil)
        end
      end

      private

      def get_user_info(token)
        return Right(mock_value) if @config.config.mock
        adapter.new.(jwt: token.jwt)
      end

      def userinfo_value(info, token)
        @user_info_value.new(
                            sub: info["sub"],
                            refresh_token: token.refresh_token,
                            access_token: token.access_token,
                            jwt: token.jwt,
                            expires_at: token.expires_at,
                            preferred_name: info["preferred_name"],
                            username: info["preferred_username"],
                            allowed_activities: activities_value(info["allowed_activities"]),
                            context_assertions: context_assertions_value(info["context_assertions"]),
                            system_user: determine_system_user(info)
                          )

      end

      def context_assertions_value(assertions)
        assertions.map {|assert| @context_assertions_value.new(activity: assert["activity_id"],
                                                                   id: assert["identifier"],
                                                                   id_type: assert["id_type"])
                          }
      end

      def activity_filter(activities)

      end

      def activities_value(activities)
        activities.select {|activity| activity.include? service }
      end

      def determine_system_user(info)
        info["preferred_username"].include? SYSTEM_USER
      end

      def service
        @config.config.identity_host
      end

      def mock_value
        {
         "sub"=>"af75c3b7-21a3-4fd1-ac85-2180f754166c",
         "email"=>nil,
         "email_verified"=>true,
         "preferred_name"=>"Test1+User",
         "preferred_username"=>"test1",
         "updated_at"=>"2016-11-29T16:04:21+13:00",
         "allowed_activities"=>[
            "lic:animal_timeline:resource:*:*",
            "lic:place:resource:*:*",
            "lic:pasture_measurement:resource:*:*",
            "lic:pasture_measurement:resource:measurement:view",
            "lic:developer:resource:authn:list"
         ],
         "context_assertions"=>
          [
            {"type"=>"identifier_assertion",
            "identifier_kind"=>"urn:lic:ids:animal_group_bp",
            "identifier"=>"5003949",
            "activity"=>"lic:animal_timeline:resource:timeline:create"},
           {"type"=>"identifier_assertion",
            "identifier_kind"=>"urn:lic:ids:animal_group_bp",
            "identifier"=>"5003949",
            "activity"=>"lic:animal_timeline:resource:timeline:update"},
           {"type"=>"identifier_assertion",
            "identifier_kind"=>"urn:lic:ids:animal_group_bp",
            "identifier"=>"5000000",
            "activity"=>"lic:animal_timeline:resource:timeline:show"},
           {"type"=>"identifier_assertion",
            "identifier_kind"=>"urn:lic:ids:farm",
            "identifier"=>"-1",
            "activity"=>"lic:places:resource:place:create"},
           {"type"=>"identifier_assertion",
            "identifier_kind"=>"urn:lic:ids:farm",
            "identifier"=>"-2",
            "activity"=>"lic:places:resource:place:create"},
           {"type"=>"identifier_assertion",
            "identifier_kind"=>"urn:lic:ids:farm",
            "identifier"=>"-1",
            "activity"=>"lic:places:resource:place:update"},
           {"type"=>"identifier_assertion",
            "identifier_kind"=>"urn:lic:ids:farm",
            "identifier"=>"-2",
            "activity"=>"lic:places:resource:place:update"},
           {"type"=>"identifier_assertion",
            "identifier_kind"=>"urn:lic:ids:farm",
            "identifier"=>"-1",
            "activity"=>"lic:places:resource:place:show"},
           {"type"=>"identifier_assertion",
            "identifier_kind"=>"urn:lic:ids:farm",
            "identifier"=>"-2",
            "activity"=>"lic:places:resource:place:show"}
          ]
        }
      end

    end

  end
end
