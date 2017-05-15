module Existence

  require 'base64'

  module Ports

    class IdentityPort

      include Dry::Monads::Either::Mixin

      attr_reader :port_service

      include Discourse::Circuit

      CONTENT_TYPES = {
        json: { content_type: "application/json", encoder: :to_json },
        form_encoding: { content_type: "application/x-www-form-urlencoded", encoder: :nil_encoder }
      }

      def initialize(port_service: Discourse::HttpPort.new)
        @port_service = port_service
      end

      def send_on_port(args)
        Right(args).bind do |value|
          begin
            Right(build_result(with_circuit do |circuit|
              circuit.service_name = args[:service]
              circuit.logger = Rails.logger
            end.call { post(port_service, args[:service], args[:resource], args[:credentials], args[:params], args[:encoding] ) } ) )
          rescue Discourse::PortException => e
            Left(nil)
          end
        end
      end

      # def get_from_port(query_params: {}, credentials:, service:, resource: nil)
      def get_from_port(args)
        Right(args).bind do |value|
          begin
            Right(build_result(with_circuit do |circuit|
              circuit.service_name = args[:resource]
            end.call { get(port_service, args[:service], args[:resource], args[:credentials], args[:query_params] ) } ) )
          rescue Discourse::PortException => e
            Left(nil)
          end
        end
      end

      def delete_to_port(args)
        Right(args).bind do |value|
          begin
            Right(build_result(with_circuit do |circuit|
              circuit.service_name = args[:resource]
            end.call { delete(port_service, args[:service], args[:resource], args[:credentials]) } ) )
          rescue Discourse::PortException => e
            Left(nil)
          end
        end
      end


      def post(port, service, resource, credentials, params, encoding)
        port.post do |p|
          p.service = service
          p.resource = resource
          p.request_body = encode(params, encoding)
          p.request_headers = { authorization: credentials}
          p.content_type = to_content_type(encoding)
        end.()
      end

      def get(port, service, resource, credentials, params)
        port.get do |p|
          p.service = service
          p.resource = resource
          p.query_params = params
          p.request_headers = { authorization: credentials }
        end.()
      end

      def delete(port, service, resource, credentials)
        port.delete do |p|
          p.service = service
          p.resource = resource
          p.request_headers = { authorization: credentials }
        end.()
      end

      def content_type(type)
        CONTENT_TYPES[type]
      end

      def to_content_type(type)
        content_map = content_type(type)
        return nil unless content_map
        content_map[:content_type]
      end

      def encode(params, type)
        content_map = content_type(type)
        return params unless content_map
        send(content_map[:encoder], params)
      end

      def to_json(params)
        params.to_json
      end

      def nil_encoder(params)
        params
      end

      def build_result(result)
        # statues:
        # + :ok
        # + :unauthorised
        # + :system_failure
        # + :fail
        # [result.status, result.body]
        result
      end

    end

  end

end
