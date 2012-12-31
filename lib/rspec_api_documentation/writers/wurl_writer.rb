module RspecApiDocumentation
  module Writers
    class WurlWriter
      def initialize(group)
        @group = group
      end

      def write
        @group.each_group do |group|
          group = RspecApiDocumentation::Mustaches::GroupWurl.new group
          mkdir group
          write_file group
        end

        @group.each_example do |example|
          example = RspecApiDocumentation::Mustaches::ExampleWurl.new example
          mkdir example
          write_file example
        end
      end

      def mkdir(item)
        FileUtils.mkdir_p(item.dir_path)
      end

      def write_file(item)
        File.open(item.file_path, "w+") do |f|
          f.write item.render
        end
      end

      def self.write(group)
        writer = new(group)
        writer.write
      end
    end
  end
end
