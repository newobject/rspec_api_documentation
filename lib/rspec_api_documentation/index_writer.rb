require "active_support/core_ext/enumerable"

module RspecApiDocumentation
  module IndexWriter
    def sections(examples, configuration)
      resources = examples.group_by(&:resource_name).inject([]) do |arr, (resource_name, examples)|
        ordered_examples = configuration.keep_source_order ? examples : examples.sort_by(&:description)
        arr.push(:resource_name => resource_name, :examples => ordered_examples)
      end
      configuration.keep_source_order ? resources : resources.sort_by { |resource| resource[:resource_name] }
    end

    def api_groups(examples, configuration)
      ApiGroupBuilder.new(examples, configuration).build.values
    end

    class ApiGroupBuilder
      def initialize(examples, configuration)
        @examples = examples
        @configuration = configuration
      end

      def build
        @root_group = {}
        @examples.each do |example|
          parse_example example
        end
        @root_group.values.each do |group|
          build_tree group
        end
        @root_group
      end

      private
      def parse_example(example)
        example_group = example.example.metadata[:example_group]
        group = build_group example_group
        add_example_to_group group, example
      end

      def build_group(example_group)
        ancestor_group_names = parse_ancestor_group_names example_group
        iterator_group_tree(ancestor_group_names)
      end

      def parse_ancestor_group_names(example_group)
        group_names = []
        eg = example_group
        while eg = eg[:example_group]
          group_names << eg[:description]
        end
        group_names.reverse!
      end

      def iterator_group_tree(ancestor_group_names)
        temp_group = @root_group

        ancestor_group_names.each do |group_name|
          group = temp_group[group_name]

          unless group
            group = { :group_name => group_name }
            temp_group[group_name] = group
          end

          temp_group = group
        end

        temp_group
      end

      def add_example_to_group(group, example)
        examples = group[:examples]

        unless examples
          examples = []
          group[:examples] = examples
        end

        examples << example
      end

      def build_tree(group)
        keys = group.keys.delete_if{|key| key.is_a? Symbol}

        if keys.any?
          sub_groups = keys.inject([]) do |sub_groups, key|
            sub_groups << group[key]
            sub_groups
          end

          group[:sub_groups] = sub_groups

          keys.each do |key|
            build_tree group[key]
          end
        else
          group[:sub_groups] = []
        end
      end
    end

    module_function :sections, :api_groups
  end
end
