module RspecApiDocumentation
  module Models
    class Group
      attr_reader :description, :examples
      attr_accessor :parent

      def initialize(description = nil)
        @description = description
        @children = {}
        @examples = []
      end

      def add_example(example)
        example.group = self
        @examples << example
        example
      end

      def children
        @children.values
      end

      def add_child(description)
        group = @children[description]

        unless group
          group = self.class.new(description)
          group.parent = self

          @children[description] = group
        end

        group
      end

      def add_descendants(descendant_descriptions)
        group = self

        descendant_descriptions.each do |description|
          group = group.add_child(description)
        end

        group
      end

      def file_name
        "index"
      end

      def dir_name
        RspecApiDocumentation::Models::Fileable.to_file_name(self.description)
      end

      def ancestors_name
        ancestors_path = ancestors.map{|g|
          RspecApiDocumentation::Models::Fileable.to_file_name(g.description)
        }.select{|name| name && !name.empty?}.join('/')

        ancestors_path
      end

      def ancestors
        the_ancestors = []
        current_group = self

        while current_group = current_group.parent
          the_ancestors << current_group
        end

        the_ancestors.reverse!
      end

      def each_group(&block)
        yield self

        children.map{|child_group| child_group.each_group &block}
      end

      def each_example(&block)
        examples.each &block
        children.map{|child_group| child_group.each_example &block}
      end
    end
  end
end
