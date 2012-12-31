module RspecApiDocumentation
  module Models
    class Example
      attr_reader :rspec_example, :configuration
      attr_accessor :group

      def initialize(configuration, rspec_example)
        @configuration = configuration
        @rspec_example = rspec_example
      end

      def file_path(suffix)
        dir_path.join(file_name(suffix))
      end

      def file_name(suffix)
        "#{self.description.titleize.downcase.tr(' ', '_')}#{suffix}"
      end

      def dir_name
        group.dir_name + '/examples'
      end

      def dir_path
        group.dir_path.join('examples')
      end

      def should_document?
        return false if pending? || !metadata[:resource_name] || !metadata[:document]
        return true if configuration.filter == :all
        return false if (Array(metadata[:document]) & Array(configuration.exclusion_filter)).length > 0
        return true if (Array(metadata[:document]) & Array(configuration.filter)).length > 0
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
