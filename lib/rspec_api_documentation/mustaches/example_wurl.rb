require 'mustache'

module RspecApiDocumentation
  module Mustaches
    class ExampleWurl < Mustache
      attr_reader :example

      def initialize(example, configuration)
        @example = example
        @configuration = configuration
        @suffix = '.html'
      end

      def has_desc
        desc_str = @example.metadata[:desc]
        desc_str.strip! if desc_str

        desc_str && !desc_str.empty?
      end

      def desc_blocks
        desc_str = @example.metadata[:desc]
        desc_str.strip! if desc_str

        return nil if desc_str.nil? || desc_str.empty?

        desc_str.split("\n\n").map{|s| s.strip}
      end

      def url_prefix
        @configuration.url_prefix
      end

      def index_and_desc
        "#{index_number}. #{description}"
      end

      def http_method_class
        case self.http_method
        when :get
          'label-info'
        when :put
          'label-warning'
        when :post
          'label-inverse'
        when :delete
          'label-important'
        else
          ''
        end
      end

      def dir_path
        [@example.ancestors_name, @example.dir_name]
          .select{|name| name && !name.empty?}
          .join('/')
      end

      def file_path
        [dir_path, @example.file_name]
          .select{|name| name && !name.empty?}
          .join('/') + @suffix
      end

      def ancestors
        groups = @example.group.ancestors
        groups << @example.group
        groups.map{|g| RspecApiDocumentation::Mustaches::GroupWurl.new g, @configuration}
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
