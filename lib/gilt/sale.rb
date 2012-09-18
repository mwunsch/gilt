require 'time'

module Gilt
  # A Gilt Sale object, representing an active or upcoming "flash" sale.
  class Sale
    class << self
      Gilt::Client::Sales.resources.keys.each do |key|
        define_method key do |params, &block|
          args = params || {}
          apikey = args[:apikey]
          affid = args[:affid]
          products = product_client apikey, affid
          req = client(apikey, affid).send(key.to_sym, args)
          response = req.perform.parse
          if response["sales"].nil?
            [self.new(response, products)]
          else
            response["sales"].map {|sale| self.new(sale, products)}
          end
        end
      end
    end

    def self.client(apikey, affid=nil)
      Gilt::Client::Sales.new(apikey, affid)
    end

    def self.product_client(apikey, affid=nil)
      Gilt::Client::Products.new(apikey, affid)
    end

    def self.create(store, sale_key, apikey, affid=nil)
      detail(:store => store, :sale_key => sale_key, :apikey => apikey, :affid => affid).first
    end

    def initialize(sale_body, client=nil)
      @sale = sale_body
      @client = client
    end

    def name
      @sale["name"]
    end

    def store
      @sale["store"].intern
    end

    def sale_key
      @sale["sale_key"]
    end

    def sale
      URI(@sale["sale"])
    end

    def sale_url
      URI(@sale["sale_url"])
    end

    def images
      @sale["image_urls"]
    end

    def description
      @sale["description"]
    end

    def begins
      Time.parse @sale["begins"]
    end

    def ends
      end_time = @sale["ends"]
      Time.parse end_time unless end_time.nil?
    end

    def ended?
      return false if ends.nil?
      ends < Time.now
    end

    def duration
      (ends - begins).ceil unless ends.nil?
    end

    def products
      return @products unless @products.nil?
      resource = Gilt::Client::Products.resources[:detail]
      @products = (@sale["products"] || []).map do |product|
        id = resource.url.extract(product)["product_id"]
        Product.defer @client.detail(:product_id => id).perform
      end
    end

    def length
      return products.length
    end

  end
end
