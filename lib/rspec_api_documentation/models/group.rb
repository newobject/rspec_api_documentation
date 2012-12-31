module RspecApiDocumentation
  module Models
    class Group
      attr_reader :description, :examples, :children
      attr_accessor :parent, :index

      def initialize(description = nil)
        @description = description
        @sorted = false
        @children_map = {}
        @children = []
        @examples = []
      end

      def add_example(example)
        example.group = self
        @examples << example
        example
      end

      def sort
        unless @sorted
          sort_examples
          sort_children
          @sorted = true
        end
      end

      def sort_examples
        @examples
          .sort!{|e1, e2| e1.description <=> e2.description}
          .each_with_index{|e, index| e.index = index + 1}
      end

      def sort_children
        example_count = @examples.size
        @children = @children_map.values
        @children.sort!{|g1, g2| g1.description <=> g2.description }
          .each_with_index{|g, index|
            g.index = example_count + index + 1
            g.sort
          }
      end

      def add_child(description)
        group = @children_map[description]

        unless group
          group = self.class.new(description)
          group.parent = self

          @children_map[description] = group
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

      def index_number
        n = ancestors_index
        n << '.' unless n.empty?
        n << index.to_s
      end

      def ancestors_index
        ancestors.select{|g| !g.parent.nil?}.map(&:index).join('.')
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
