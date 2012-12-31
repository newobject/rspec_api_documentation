require 'mustache'

module RspecApiDocumentation
  module Mustaches
    class GroupWurl < Mustache
      def initialize(group)
        @group = group
        self.template_path = group.configuration.template_path
        Mustache.template_path = self.template_path
        @suffix = '.html'
      end

      def examples
        unless @examples
          @examples = @group.examples.map{|e| RspecApiDocumentation::Mustaches::ExampleWurl.new e}
        end

        @examples
      end

      def children
        unless @children
          @children = @group.children.map{|g| RspecApiDocumentation::Mustaches::GroupWurl.new g}
        end

        @children
      end

      def api_name
        @group.configuration.api_name
      end

      def url_prefix
        @group.configuration.url_prefix
      end

      def file_path
        @group.file_path(@suffix)
      end

      def filename
        @group.file_name(@suffix)
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
