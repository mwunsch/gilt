require 'spec_helper'
require 'gilt/sku'

describe Gilt::Sku do
  before do
    @body = {
      :id => 1445982,
      :inventory_status => "sold out",
      :msrp_price => "449.00",
      :sale_price => "340.00",
      :attributes => [{
        :name => "color",
        :value => "choc brown"
      }]
    }
    @json = MultiJson.encode(@body)
  end

  describe "#id" do
    it "returns the sku id" do
      sku = Gilt::Sku.new(MultiJson.decode(@json))
      sku.id.should eql 1445982
    end
  end

  describe "#inventory_status" do
    it "returns the inventory state of the sku" do
      sku = Gilt::Sku.new(MultiJson.decode(@json))
      sku.inventory_status.should eql Gilt::Sku::SOLD_OUT
    end
  end

  describe "#for_sale?" do
    before do
      @sku_body = MultiJson.decode(@json)
    end

    it "is true when the sku is for sale" do
      @sku_body["inventory_status"] = Gilt::Sku::FOR_SALE
      sku = Gilt::Sku.new(@sku_body)
      sku.for_sale?.should be_true
    end

    it "is false when the sku is sold out or reserved" do
      @sku_body["inventory_status"] = Gilt::Sku::SOLD_OUT
      sku = Gilt::Sku.new(@sku_body)
      sku.for_sale?.should_not be_true
    end
  end

  describe "#reserved?" do
    before do
      @sku_body = MultiJson.decode(@json)
    end

    it "is true when the sku is reserved" do
      @sku_body["inventory_status"] = Gilt::Sku::RESERVED
      sku = Gilt::Sku.new(@sku_body)
      sku.reserved?.should be_true
    end

    it "is false when the sku is for sale or sold out" do
      @sku_body["inventory_status"] = Gilt::Sku::SOLD_OUT
      sku = Gilt::Sku.new(@sku_body)
      sku.reserved?.should_not be_true
    end
  end

  describe "#sold_out?" do
    before do
      @sku_body = MultiJson.decode(@json)
    end

    it "is true when the sku is sold out" do
      @sku_body["inventory_status"] = Gilt::Sku::SOLD_OUT
      sku = Gilt::Sku.new(@sku_body)
      sku.sold_out?.should be_true
    end

    it "is false when the sku is for sale or reserved" do
      @sku_body["inventory_status"] = Gilt::Sku::FOR_SALE
      sku = Gilt::Sku.new(@sku_body)
      sku.sold_out?.should_not be_true
    end
  end

  describe "#msrp_price" do
    it "returns the price as a Money object" do
      sku = Gilt::Sku.new MultiJson.decode(@json)
      sku.msrp_price.should be_kind_of ::Money
    end
  end

  describe "#sale_price" do
    it "returns the price as a Money object" do
      sku = Gilt::Sku.new MultiJson.decode(@json)
      sku.sale_price.should be_kind_of ::Money
    end
  end

  describe "#shipping_surcharge" do
    before do
      @sku_body = MultiJson.decode(@json)
    end

    it "returns the surcharge as a Money object" do
      sku = Gilt::Sku.new @sku_body
      sku.shipping_surcharge.should be_kind_of ::Money
    end

    it "is zero dollars when there is no surcharge" do
      sku = Gilt::Sku.new @sku_body
      sku.shipping_surcharge.should be_zero
    end
  end

  describe "#subtotal" do
    before do
      @sku_body = MultiJson.decode(@json)
    end

    it "returns a Money object of the sale price plus the shipping surcharge" do
      @sku_body["shipping_surcharge"] = "5.00"
      sku = Gilt::Sku.new @sku_body
      sku.subtotal.to_s.should eql "345.00"
    end
  end

  describe "#sale?" do
    it "is true if the sale price and the msrp price do not match" do
      sku = Gilt::Sku.new MultiJson.decode(@json)
      sku.sale?.should be_true
    end
  end

  describe "#attributes" do
    before do
      @sku_body = MultiJson.decode(@json)
    end

    it "maps the names of the attribute to their values as symbols" do
      sku = Gilt::Sku.new @sku_body
      sku.attributes[:color].should match /brown/
    end
  end

end