require 'spec_helper'

describe Gilt::Sale do
  before do
    @apikey = "my-api-key"
    @affid = "my-affiliate-id"
    @sale_key = "shoshanna-019"
    stub_request(:any, /api\.gilt\.com\/.+\/sales\/.+\/detail\.json/).to_return fixture('sale_detail.json')
    stub_request(:any, /api\.gilt\.com\/.+\/sales\/.*(active|upcoming)\.json/).to_return fixture('active.json')
    stub_request(:any, /api\.gilt\.com\/.+\/products\/.+\/detail\.json/).to_return fixture('product.json')
  end

  describe "::client" do
    it "creates a new instance of the Sales client" do
      described_class.client(@apikey, @affid).should be_kind_of Gilt::Client::Sales
    end
  end

  describe "::create" do
    it "creates an instance of Sale from the request response" do
      sale = described_class.create(Gilt::Stores::WOMEN, @sale_key, @apikey)
      sale.should be_instance_of described_class
    end
  end

  Gilt::Client::Sales.resources.keys.each do |key|
    describe "::#{key}" do
      it "creates a set of instances of Sale" do
        set = described_class.send(key, :store => Gilt::Stores::WOMEN, :sale_key => @sale_key, :apikey => @apikey)
        set.should be_all {|sale| sale.is_a? described_class }
      end
    end
  end

  describe "#name" do
    before do
      @sale = described_class.create(Gilt::Stores::WOMEN, @sale_key, @apikey)
    end

    it "returns the sale's name" do
      @sale.name.should match /Shoshanna/
    end
  end

  describe "#store" do
    before do
      @sale = described_class.create(Gilt::Stores::WOMEN, @sale_key, @apikey)
    end

    it "returns the sale's store" do
      @sale.store.should eq Gilt::Stores::WOMEN
    end
  end

  describe "#sale_key" do
    before do
      @sale = described_class.create(Gilt::Stores::WOMEN, @sale_key, @apikey)
    end

    it "returns the sale's sale key" do
      @sale.sale_key.should match /^shoshanna/
    end
  end

  describe "#sale" do
    before do
      @sale = described_class.create(Gilt::Stores::WOMEN, @sale_key, @apikey)
    end

    it "returns a URI representation of the sale's endpoint" do
      @sale.sale.to_s.should match "/sales/#{Gilt::Stores::WOMEN}/#{@sale.sale_key}/"
    end
  end

  describe "#sale_url" do
    before do
      @sale = described_class.create(Gilt::Stores::WOMEN, @sale_key, @apikey)
    end

    it "returns a URI representation of the sale page" do
      @sale.sale_url.to_s.should match "www.gilt.com/sale/women/#{@sale.sale_key}"
    end
  end

  describe "#begins" do
    before do
      @sale = described_class.create(Gilt::Stores::WOMEN, @sale_key, @apikey)
    end

    it "returns a Time representation of the sale begin time" do
      @sale.begins.day.should eql 5
    end
  end

  describe "#ends" do
    before do
      @sale = described_class.create(Gilt::Stores::WOMEN, @sale_key, @apikey)
    end

    it "returns a Time representation of the sale end time" do
      @sale.ends.day.should eql 7
    end
  end

  describe "#ended?" do
    before do
      @sale = described_class.create(Gilt::Stores::WOMEN, @sale_key, @apikey)
    end

    it "is true unless you have traveled back in time" do
      @sale.ended?.should be_true
    end
  end

  describe "#duration" do
    before do
      @sale = described_class.create(Gilt::Stores::WOMEN, @sale_key, @apikey)
    end

    it "returns the number of seconds between begin and end" do
      (@sale.duration / 60 / 60).should eql 36
    end
  end

  describe "#products" do
    before do
      @sale = described_class.create(Gilt::Stores::WOMEN, @sale_key, @apikey)
    end

    it "returns a map of product requests" do
      @sale.products.should be_all {|p| p.is_a? Gilt::Product }
    end
  end

  describe "#length" do
    before do
      @sale = described_class.create(Gilt::Stores::WOMEN, @sale_key, @apikey)
    end

    it "returns the size of the products array" do
      @sale.length.should eq @sale.products.length
    end

  end

end