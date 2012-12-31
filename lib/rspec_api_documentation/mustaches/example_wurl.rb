require 'mustache'

module RspecApiDocumentation
  module Mustaches
    class ExampleWurl < Mustache
      def initialize(example)
        @example = example
        self.template_path = example.group.configuration.template_path
        Mustache.template_path = self.template_path
        @suffix = '.html'
      end

      def file_path
        @example.file_path(@suffix)
      end

      def fname
        @example.file_name(@suffix)
      end

      def method_missing(method, *args, &block)
        @example.send(method, *args, &block)
      end

      def respond_to?(method, include_private = false)
        super || @example.respond_to?(method, include_private)
      end

      def requests
        super.collect do |hash|
          hash[:request_headers_hash] = hash[:request_headers].collect { |k, v| {:name => k, :value => v} }
          hash[:request_headers_text] = format_hash(hash[:request_headers])
          hash[:request_path_no_query] = hash[:request_path].split('?').first
          hash[:request_query_parameters_text] = format_hash(hash[:request_query_parameters])
          hash[:request_query_parameters_hash] = hash[:request_query_parameters].collect { |k, v| {:name => k, :value => v} } if hash[:request_query_parameters].present?
          hash[:response_headers_text] = format_hash(hash[:response_headers])
          hash[:response_status] = hash[:response_status].to_s + " " + Rack::Utils::HTTP_STATUS_CODES[hash[:response_status]].to_s
          if @host
            hash[:curl] = hash[:curl].output(@host) if hash[:curl].is_a? RspecApiDocumentation::Curl
          else
            hash[:curl] = nil
          end
          hash
        end
      end

      def url_prefix
        @example.group.configuration.url_prefix
      end

      private
      def format_hash(hash = {})
        return nil unless hash.present?
        hash.collect do |k, v|
          "#{k}: #{v}"
        end.join("\n")
      end
    end
  end
end
