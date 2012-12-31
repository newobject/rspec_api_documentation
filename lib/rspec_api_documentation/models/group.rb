module RspecApiDocumentation
  module Models
    class Group
      attr_reader :configuration, :description, :examples
      attr_accessor :parent

      def initialize(configuration, description = nil)
        @configuration = configuration
        @description = description
        @children = {}
        @examples = []
      end

      def each_group(&block)
        yield self

        children.map{|child_group| child_group.each_group &block}
      end

      def each_example(&block)
        examples.each &block
        children.map{|child_group| child_group.each_example &block}
      end

      def children
        @children.values
      end

      def add_example(example)
        example.group = self

        @examples << example
        example
      end

      def add_child(description)
        group = @children[description]

        unless group
          group = RspecApiDocumentation::Models::Group.new(configuration, description)
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

      def file_path(suffix)
        dir_path.join(file_name(suffix))
      end

      def file_name(suffix)
        "index#{suffix}"
      end

      def dir_name
        ancestors_path = ancestors.map{|g|
          desc = g.description
          desc = '' unless desc
          desc.downcase
        }.join('/')

        ancestors_path.slice!(0) if ancestors_path.start_with?('/')

        ancestors_path
      end

      def dir_path
        configuration.docs_dir.join(dir_name)
      end

      def ancestors
        the_ancestors = [self]
        current_group = self

        while current_group = current_group.parent
          the_ancestors << current_group
        end

        the_ancestors.reverse!
      end
    end
  end
end
