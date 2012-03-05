module Gilt
  autoload :Sku, "gilt/sku"
  class Product

    def self.client(apikey, affid=nil)
      Gilt::Client::Products.new(apikey, affid)
    end

    def self.detail(product_id, apikey, affid=nil)
      client(apikey, affid).detail(:product_id => product_id)
    end

    def self.create(product_id, apikey, affid=nil)
      response = detail(product_id, apikey, affid).perform
      self.new response.parse
    end

    def initialize(product_body)
      @product = product_body
    end

    def name
      @product["name"]
    end

    def product
      URI(@product["product"])
    end

    def id
      @product["id"].to_i
    end

    def brand
      @product["brand"]
    end

    def url
      URI(@product["url"])
    end

    def description
      fetch_content :description
    end

    def fit_notes
      fetch_content :fit_notes
    end

    def material
      fetch_content :material
    end

    def care_instructions
      fetch_content :care_instructions
    end

    def origin
      fetch_content :origin
    end

    def content
      keys = [:description, :fit_notes, :material, :care_instructions, :origin]
      Hash[keys.map {|content| [content, self.send(content) ]}]
    end

    def skus
      @product["skus"].map {|sku| Sku.new(sku) }
    end

    private

    def fetch_content(key)
      content = @product["content"]
      content[key.to_s] unless content.nil?
    end
  end
end