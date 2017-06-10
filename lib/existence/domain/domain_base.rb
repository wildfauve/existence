require_relative 'service_error_value'
require_relative 'service_error_attr_value'
require_relative 'link_value'

module Existence

  module Domain

    class DomainBase

      ERROR_OBJECT = "_status"

      def initialize(config: Configuration,
                     service_error_value: ServiceErrorValue,
                     service_error_attr_value: ServiceErrorAttrValue,
                     link_value: LinkValue,
                     **)
        @config = config.config
        @link_value = link_value
        @service_error_value = service_error_value
        @service_error_attr_value = service_error_attr_value
      end

      private

      def build_links(type:, links:, id: )
        return [] unless links.present? || id
        return links_from_id(type, id) if links.nil? || links.empty?
        links.map do |link|
          if link["rel"] == "self"
            @link_value.new(rel: type, href: link["href"])
          else
            @link_value.new(rel: link["rel"], href: link["href"])
          end
        end
      end

      def links_from_id(type, id)
        [@link_value.new(rel: type, href: id)]
      end

      def service_error(error)
        return Left(error) unless error && error.body && error.instance_of?(HttpResponseValue)
        Left(build_error_value(error.body[ERROR_OBJECT]))
      end

      def build_error_value(error)
        @service_error_value.new(code: error["code"],
                                 message: error["message"],
                                 attributes: build_attributes(error["attributes"]))
      end

      def build_attributes(error_attrs)
        return [] unless error_attrs
        error_attrs.map do |attr|
          @service_error_attr_value.new(attribute: attr["attribute"], message: attr["message"])
        end
      end

    end

  end

end
