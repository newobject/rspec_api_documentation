require 'mustache'

module RspecApiDocumentation
  module Mustaches
    class GroupWurl < Mustache
      attr_reader :group

      def initialize(group, configuration)
        @group = group
        @configuration = configuration
        @suffix = '.html'
      end

      def api_name
        @configuration.api_name
      end

      def url_prefix
        @configuration.url_prefix
      end

      def dir_path
        [@group.ancestors_name, @group.dir_name]
          .select{|name| name && !name.empty?}
          .join('/')
      end

      def file_path
        [dir_path, @group.file_name]
          .select{|name| name && !name.empty?}
          .join('/') + @suffix
      end

      def description
        return 'Home' if @group.parent.nil?
        @group.description
      end

      def index_and_desc
        return 'Home' if @group.parent.nil?
        "#{index_number}. #{@group.description}"
      end

      def ancestors
        @group.ancestors.map{|g| self.class.new g, @configuration}
      end

      def children
        unless @children
          @children = @group.children.map{|g| RspecApiDocumentation::Mustaches::GroupWurl.new g, @configuration}
        end

        @children
      end

      def examples
        unless @examples
          @examples = @group.examples.map{|e| RspecApiDocumentation::Mustaches::ExampleWurl.new e, @configuration}
        end

        @examples
      end

      def sort
        @group.sort
      end

      def method_missing(method, *args, &block)
        @group.send(method, *args, &block)
      end

      def respond_to?(method, include_private = false)
        super || @group.respond_to?(method, include_private)
      end

    end
  end
end
