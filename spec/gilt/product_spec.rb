require 'spec_helper'

describe Gilt::Product do
  before do
    @apikey = "my-api-key"
    @affid = "my-affiliate-id"
    stub_request(:any, /api\.gilt\.com\/.*detail.*/).to_return fixture('product.json')
    stub_request(:any, /api\.gilt\.com\/.*categories.*/).to_return fixture('categories.json')
  end

  describe "::defer" do
    it "asynchronously defers the product instantiation" do
      detail = described_class.detail("a-product-id", @apikey)
      described_class.defer(detail.perform).class.should be described_class
    end
  end

  describe "::client" do
    it "creates a new instance of the Products client" do
      described_class.client(@apikey, @affid).should be_kind_of Gilt::Client::Products
    end
  end

  describe "::detail" do
    it "generates a request for the details of a product" do
      detail = described_class.detail("a-product-id", @apikey)
      detail.should be_kind_of Weary::Request
    end
  end

  describe "::create" do
    it "creates an instance of Product from the request response" do
      described_class.create("a-product-id", @apikey).should be_instance_of described_class
    end
  end

  describe "::categories" do
    it "gets a list of active product categories" do
      categories = described_class.categories(@apikey, @affid)
      categories.length.should eql 130
    end
  end

  describe "#name" do
    it "returns the product's name" do
      product = described_class.create("a-product-id", @apikey)
      product.name.should eql "514 Slim Jeans"
    end
  end

  describe "#product" do
    it "returns a URI representation of the product's endpoint" do
      product = described_class.create("a-product-id", @apikey)
      product.product.to_s.should eql "https://api.gilt.com/v1/products/73794592/detail.json"
    end
  end

  describe "#id" do
    it "returns the id of the product" do
      product = described_class.create("a-product-id", @apikey)
      product.id.should eql 73794592
    end
  end

  describe "#brand" do
    it "returns the brand name of the product" do
      product = described_class.create("a-product-id", @apikey)
      product.brand.should eql "Levi's Red Tab"
    end
  end

  describe "#url" do
    it "returns a URI representation of the product's detail page" do
      product = described_class.create("a-product-id", @apikey)
      product.url.to_s.should match "www.gilt.com/sale/men/"
    end
  end

  describe "#categories" do
    it "returns an array of strings of categories in which this product belongs" do
      product = described_class.create("a-product-id", @apikey)
      product.categories.should include "Denim"

    end
  end

  describe "#description" do
    it "returns the product description" do
      product = described_class.create("a-product-id", @apikey)
      product.description.should match /^five pocket cotton slim leg/i
    end
  end

  describe "#fit_notes" do
    it "returns the product's sizing information" do
      product = described_class.create("a-product-id", @apikey)
      product.fit_notes.should match "Straight Leg"
    end
  end

  describe "#material" do
    it "returns the product's material" do
      product = described_class.create("a-product-id", @apikey)
      product.material.should match /cotton/i
    end
  end

  describe "#care_instructions" do
    it "returns details about how to care for the product" do
      product = described_class.create("a-product-id", @apikey)
      product.care_instructions.should be_nil
    end
  end

  describe "#origin" do
    it "returns the location where the product originates" do
      product = described_class.create("a-product-id", @apikey)
      product.origin.should match /mexico/i
    end
  end

  describe "#content" do
    it "returns a hash of the content of the product with symbols for keys" do
      product = described_class.create("a-product-id", @apikey)
      product.content.keys.size.should eql 5
    end
  end

  describe "#skus" do
    it "returns a mapping of skus to Sku objects" do
      product = described_class.create("a-product-id", @apikey)
      product.skus.all? {|sku| sku.is_a?(Gilt::Sku) }.should be_true
    end
  end

  describe "#images" do
    it "returns the mapping of image urls" do
      product = described_class.create("a-product-id", @apikey)
      product.images.should have_key "91x121"
    end
  end

  describe "#min_price" do
    it "returns the min price of the skus" do
      product = described_class.create("a-product-id", @apikey)
      product.min_price.to_s.should eql "68.00"
    end
  end

  describe "#max_price" do
    it "returns the max price of the skus" do
      product = described_class.create("a-product-id", @apikey)
      product.min_price.to_s.should eql "68.00"
    end
  end

  describe "#price_range" do
    it "returns a tuple of the min and max price" do
      product = described_class.create("a-product-id", @apikey)
      product.price_range.should eql [product.min_price, product.max_price]
    end
  end

  describe "#format_price" do
    it "prints the price range of the product, or if both min and max are equal, the price" do
      product = described_class.create("a-product-id", @apikey)
      product.format_price.should eql "$68.00"
    end
  end

  describe "#colors" do
    it "returns a set of all the possible colors for the product" do
      product = described_class.create("a-product-id", @apikey)
      product.colors.first.should match /rumpled/
    end
  end

  describe "#sizes" do
    it "returns a set of all the possible sizes for the product" do
      product = described_class.create("a-product-id", @apikey)
      product.sizes.length.should eql product.skus.length
    end
  end

  describe "#skus_of_size" do
    it "select the skus of the given size" do
      product = described_class.create("a-product-id", @apikey)
      first_size = product.sizes.first
      sku_set = product.skus_of_size first_size
      sku_set.all? {|sku| sku.attributes[:size] == first_size }.should be_true
    end
  end

  describe "#skus_of_color" do
    it "selects the skus of the given color" do
      product = described_class.create("a-product-id", @apikey)
      first_color = product.colors.first
      sku_set = product.skus_of_color first_color
      sku_set.all? {|sku| sku.attributes[:color] == first_color }.should be_true
    end
  end

  describe "#skus_with_attribute" do
    it "selects the skus with the given attribute and value" do
      product = described_class.create("a-product-id", @apikey)
      first_size = product.sizes.first
      sku_set = product.skus_with_attribute(:size, first_size)
      sku_set.all? {|sku| sku.attributes[:size] == first_size}.should be_true

    end
  end

  describe "#select_sku" do
    it "selects a sku given a size and a color" do
      product = described_class.create("a-product-id", @apikey)
      last_size = product.sizes.last
      first_color = product.colors.first
      product.select_sku(:size => last_size, :color => first_color).attributes[:size].should eql last_size
    end
  end

  describe "#inventory_status" do
    it "returns the most optimistic inventory status for the product" do
      product = described_class.create("a-product-id", @apikey)
      product.inventory_status.should eql Gilt::Sku::FOR_SALE
    end
  end
end