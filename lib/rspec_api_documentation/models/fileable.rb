module RspecApiDocumentation
  module Models
    module Fileable
      def self.to_file_name(string)
        return nil if string.nil?

        string.titleize.downcase.tr(' ', '_')
      end
    end
  end
end
