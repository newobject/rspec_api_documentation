require "rspec_api_documentation/dsl/group"
require "rspec_api_documentation/dsl/endpoint"
require "rspec_api_documentation/dsl/callback"

def self.group(*args, &block)
  options = if args.last.is_a?(Hash) then args.pop else {} end
  options[:api_doc_dsl] = :resource
  options[:group_name] = args.first
  options[:document] ||= :all
  args.push(options)
  describe(*args, &block)
end

def self.resource(*args, &block)
  group(*args, &block)
end

RSpec.configuration.include RspecApiDocumentation::DSL::Group, :api_doc_dsl => :group
RSpec.configuration.include RspecApiDocumentation::DSL::Group, :api_doc_dsl => :resource
RSpec.configuration.include RspecApiDocumentation::DSL::Endpoint, :api_doc_dsl => :endpoint
RSpec.configuration.include RspecApiDocumentation::DSL::Callback, :api_doc_dsl => :callback
RSpec.configuration.backtrace_clean_patterns << %r{lib/rspec_api_documentation/dsl\.rb}
