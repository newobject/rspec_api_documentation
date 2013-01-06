module RspecApiDocumentation
  module Rspec
    class ExampleParser
      class << self
        def parse_example(rspec_example)
          group_descriptions = []

          #example_group = rspec_example.metadata[:example_group]
          example_group = rspec_example.metadata
          while example_group = example_group[:example_group]
            group_descriptions << example_group[:description]
          end

          group_descriptions.reverse!
        end
      end
    end
  end
end
