require 'spec_helper'

describe Gilt::Product do
  before do
    @apikey = "my-api-key"
    @affid = "my-affiliate-id"
    stub_request(:any, /api\.gilt\.com\/.*/).to_return fixture('product.json')
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

  describe "#name" do
    it "returns the product's name" do
      product = described_class.create("a-product-id", @apikey)
      product.name.should eql "501 Classic Jeans"
    end
  end

  describe "#product" do
    it "returns a URI representation of the product's endpoint" do
      product = described_class.create("a-product-id", @apikey)
      product.product.to_s.should eql "https://api.gilt.com/v1/products/73794579/detail.json"
    end
  end

  describe "#id" do
    it "returns the id of the product" do
      product = described_class.create("a-product-id", @apikey)
      product.id.should eql 73794579
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
      product.url.to_s.should match "www.gilt.com/m/public/look/"
    end
  end

  describe "#description" do
    it "returns the product description" do
      product = described_class.create("a-product-id", @apikey)
      product.description.should match /^five pocket straight leg/i
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
  end
end