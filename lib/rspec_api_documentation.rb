require 'active_support'
require 'active_support/inflector'
require 'cgi'
require 'json'

require 'rspec_api_documentation/rspec/example_parser'
require 'rspec_api_documentation/models/fileable'
require 'rspec_api_documentation/models/group'
require 'rspec_api_documentation/models/example'
require 'rspec_api_documentation/mustaches/group_wurl'
require 'rspec_api_documentation/mustaches/example_wurl'
require 'rspec_api_documentation/writers/wurl_writer'

module RspecApiDocumentation
  extend ActiveSupport::Autoload

  require 'rspec_api_documentation/railtie' if defined?(Rails)
  include ActiveSupport::JSON

  eager_autoload do
    autoload :Configuration
    autoload :ApiDocumentation
    autoload :ApiFormatter
    autoload :ClientBase
    autoload :Headers
  end

  autoload :DSL
  autoload :RackTestClient
  autoload :OAuth2MACClient, "rspec_api_documentation/oauth2_mac_client"
  autoload :TestServer
  autoload :Curl

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.documentations
    @documentations ||= configuration.map { |config| ApiDocumentation.new(config) }
  end

  def self.configure
    yield configuration if block_given?
  end
end
