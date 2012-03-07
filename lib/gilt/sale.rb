require 'time'

module Gilt
  class Sale
    def self.client(apikey, affid=nil)
      Gilt::Client::Sales.new(apikey, affid)
    end

    def self.product_client(apikey, affid=nil)
      Gilt::Client::Products.new(apikey, affid)
    end

    def self.detail(store, sale_key, apikey, affid=nil)
      client(apikey, affid).detail :store => store,
                                   :sale_key => sale_key
    end

    def self.create(store, sale_key, apikey, affid=nil)
      response = detail(store, sale_key, apikey, affid).perform
      self.new response.parse, product_client(apikey, affid)
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
      @products = @sale["products"].map do |product|
        id = resource.url.extract(product)["product_id"]
        @client.detail(:product_id => id).perform
        Product.defer @client.detail(:product_id => id).perform
      end
    end

    def length
      return products.length
    end

  end
end