require 'spec_helper'

describe Gilt::Client::Products do
  before do
    @apikey = "my-api-key"
    @affid = "my-affiliate-id"
    @client = described_class.new @apikey, @affid
    stub_request :any, /api\.gilt\.com\/.*/
  end

  describe "::domain" do
    it "points to the api.gilt.com domain" do
      described_class.domain.should match "api.gilt.com/v1"
    end
  end

  describe "#initialize" do
    it "inherits from Weary::Client" do
      @client.should be_kind_of Weary::Client
    end
  end

  describe "#detail" do
    it "generates a request to get the details for a product" do
      detail = @client.detail :product_id => "a-product-id"
      detail.uri.to_s.should match "/products/a-product-id/detail"
    end

    it "raises an error when no product id is given" do
      expect { @client.detail }.to raise_error Weary::Resource::UnmetRequirementsError
    end
  end

  describe "#categories" do
    it "generates a request to get the categories of active products" do
      categories = @client.categories
      categories.uri.to_s.should match "/categories.json"
    end
  end
end