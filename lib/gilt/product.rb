module Gilt
  autoload :Sku, "gilt/sku"

  class Product

    def self.defer(future)
      require 'weary/deferred'
      Weary::Deferred.new future, self, lambda {|product, response| product.new(response.parse) }
    end

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

    def self.categories(apikey, affid=nil)
      response = client(apikey, affid).categories.perform
      response.parse["categories"] || []
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

    def categories
      @product["categories"] || []
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

    def min_price
      sorted_price.last
    end

    def max_price
      sorted_price.first
    end

    def price_range
      [min_price, max_price]
    end

    def format_price
      range = price_range
      return range.first.format if range.first == range.last
      price_range.map(&:format).join(" - ")
    end

    def images
      @product["image_urls"]
    end

    def colors
      skus.map {|sku| sku.attributes[:color] }.uniq
    end

    def sizes
      skus.map {|sku| sku.attributes[:size] }.uniq
    end

    def skus_of_size(size)
      skus_with_attribute :size, size
    end

    def skus_of_color(color)
      skus_with_attribute :color, color
    end

    def skus_with_attribute(attribute, value)
      skus.select {|sku| !!sku.attributes[attribute.to_sym].match(value) }
    end

    def select_sku(attributes)
      attribute_map = attributes.map {|k, v| skus_with_attribute(k, v).map(&:id) }
      ids = attribute_map.reduce(:&)
      skus.find {|sku| sku.id == ids.first } if ids.size > 0
    end

    def inventory_status
      sku_inventory = skus.map(&:inventory_status).uniq
      if sku_inventory.include? Gilt::Sku::FOR_SALE
        Gilt::Sku::FOR_SALE
      elsif sku_inventory.all? {|status| status == Gilt::Sku::RESERVED}
        Gilt::Sku::RESERVED
      else
        Gilt::Sku::SOLD_OUT
      end
    end

    def for_sale?
      inventory_status == Gilt::Sku::FOR_SALE
    end

    def sold_out?
      inventory_status == Gilt::Sku::SOLD_OUT
    end

    def reserved?
      inventory_status == Gilt::Sku::RESERVED
    end

    private

    def fetch_content(key)
      content = @product["content"]
      content[key.to_s] unless content.nil?
    end

    def sorted_price
      set = skus.map(&:sale_price).uniq
      return set if set.size == 1
      set.sort
    end

  end
end