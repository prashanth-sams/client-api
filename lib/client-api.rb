require "client-api/version"
require "client-api/request"
require "client-api/base"
require "client-api/validator"
require "client-api/loggers"


module ClientApi
  include Loggers

  class Configuration
    attr_accessor   :base_url, :headers, :basic_auth, :json_output, :time_out

    def initialize
      @base_url = ''
      @headers = {}
      @basic_auth = {}
      @json_output = {}
      @time_out = 10
    end


  end

  class << self
    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def reset
      @configuration = Configuration.new
    end
  end
end