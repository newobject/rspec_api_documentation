module RspecApiDocumentation
  module Writers
    class WurlWriter
      def initialize(group, configuration)
        @group = group
        @configuration = configuration
      end

      def write
        @group.each_group do |group|
          group = RspecApiDocumentation::Mustaches::GroupWurl.new group, @configuration
          write_to_file group
        end

        @group.each_example do |example|
          example = RspecApiDocumentation::Mustaches::ExampleWurl.new example, @configuration
          write_to_file example
        end
      end

      def self.write(group, configuration)
        writer = new(group, configuration)
        writer.write
      end

      private
      def write_to_file(item)
        pp "#{item.description}, #{item.file_path}"
        mkdir item
        save_file item
      end

      def mkdir(item)
        FileUtils.mkdir_p(@configuration.docs_dir.join(item.dir_path)) unless item.dir_path.empty?
      end

      def save_file(item)
        File.open(@configuration.docs_dir.join(item.file_path), "w+") do |f|
          f.write item.render
        end
      end
    end
  end
end
