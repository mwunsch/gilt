require "weary/client"

module Gilt
  class Client < Weary::Client
    VERSION = "v1"
    FORMAT = "json"
    DOMAIN = "https://api.gilt.com/#{VERSION}"

    def initialize(apikey, affid=nil)
      @defaults = {}
      @defaults[:apikey] = apikey
      @defaults[:affid]  = affid unless affid.nil?
    end

    autoload :Sales, "gilt/client/sales"
    autoload :Products, "gilt/client/products"
  end
end