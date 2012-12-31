module RspecApiDocumentation
  class ApiDocumentation
    attr_reader :configuration, :group

    delegate :docs_dir, :format, :to => :configuration

    def initialize(configuration)
      @configuration = configuration
      @group = RspecApiDocumentation::Models::Group.new configuration
    end

    def clear_docs
      if File.exists?(docs_dir)
        FileUtils.rm_rf(docs_dir, :secure => true)
      end
      FileUtils.mkdir_p(docs_dir)
      FileUtils.cp_r(File.join(configuration.template_path, "assets"), docs_dir)
    end

    def document_example(rspec_example)
      group_descriptions = RspecApiDocumentation::Rspec::ExampleParser.parse_example(rspec_example)

      last_group = @group.add_descendants(group_descriptions)

      example = RspecApiDocumentation::Models::Example.new configuration, rspec_example
      if example.should_document?
        last_group.add_example(example)
      end
    end

    def write
      writers.each do |writer|
        writer.write(group)
      end
    end

    def writers
      [*configuration.format].map do |format|
        RspecApiDocumentation::Writers.const_get("#{format}_writer".classify)
      end
    end
  end
end
