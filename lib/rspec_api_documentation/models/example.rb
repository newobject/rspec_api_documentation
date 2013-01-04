module RspecApiDocumentation
  module Models
    class Example
      attr_reader :rspec_example
      attr_accessor :group, :index

      def initialize(rspec_example)
        @rspec_example = rspec_example
      end

      def file_name
        RspecApiDocumentation::Models::Fileable.to_file_name(self.description)
      end

      def dir_name
        'examples'
      end

      def ancestors_name
        [self.group.ancestors_name, self.group.dir_name]
          .select{|name| name && !name.empty?}
          .join('/')
      end

      def http_method
        self.rspec_example.metadata[:method]
      end

      def index_number
        n = ancestors_index
        n << '.' unless n.empty?
        n << index.to_s
      end

      def ancestors_index
        ancestors.select{|g| !g.parent.nil?}.map(&:index).join('.')
      end

      def ancestors
        group.ancestors + [group]
      end

      def should_document?
        return false if pending? || !metadata[:group_name] || !metadata[:document]
        true
      end

      def method_missing(method_sym, *args, &block)
        if rspec_example.metadata.has_key?(method_sym)
          rspec_example.metadata[method_sym]
        else
          rspec_example.send(method_sym, *args, &block)
        end
      end

      def respond_to?(method_sym, include_private = false)
        super || rspec_example.metadata.has_key?(method_sym) || rspec_example.respond_to?(method_sym, include_private)
      end
    end
  end
end
