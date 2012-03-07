require 'spec_helper'

describe Gilt::Client::Sales do
  before do
    @apikey = "my-api-key"
    @affid = "my-affiliate-id"
    @client = described_class.new @apikey, @affid
    stub_request :any, /api\.gilt\.com\/.*/
  end

  describe "#initialize" do
    it "inherits from Weary::Client" do
      @client.should be_kind_of Weary::Client
    end
  end

  describe "::domain" do
    it "points to the api.gilt.com domain" do
      described_class.domain.should match "api.gilt.com/v1"
    end
  end

  describe "#active" do
    it "generates a request to fetch active sales" do
      @client.active.uri.to_s.should match "/sales/active"
    end
  end

  describe "#active_in_store" do
    it "generates a request to fetch active sales in a given store" do
      active = @client.active_in_store :store => Gilt::Stores::WOMEN
      active.uri.to_s.should match "/sales/women/active"
    end

    it "raises an error when store is not passed in" do
      expect { @client.active_in_store }.to raise_error Weary::Resource::UnmetRequirementsError
    end
  end

  describe "#upcoming" do
    it "generates a request to fetch upcoming sales" do
      @client.upcoming.uri.to_s.should match "/sales/upcoming"
    end
  end

  describe "#upcoming_in_store" do
    it "generates a request to fetch upcoming sales in a given store" do
      upcoming = @client.upcoming_in_store :store => Gilt::Stores::WOMEN
      upcoming.uri.to_s.should match "/sales/women/upcoming"
    end

    it "raises an error when store is not passed in" do
      expect { @client.upcoming_in_store }.to raise_error Weary::Resource::UnmetRequirementsError
    end
  end

  describe "#detail" do
    it "generates a request to fetch details of a particular sale" do
      details = @client.detail :store => Gilt::Stores::WOMEN, :sale_key => "a-dress-sale"
      details.uri.to_s.should match "/sales/women/a-dress-sale/detail"
    end

    it "raises an error when sale key is not passed in" do
      expect { @client.detail :store => Gilt::Stores::WOMEN }.to raise_error
    end
  end

  [Gilt::Stores::WOMEN, Gilt::Stores::MEN, Gilt::Stores::KIDS, Gilt::Stores::HOME].each do |store|
    describe "#active_in_#{store}" do
      it "generates a dynamic method for the store" do
        @client.should respond_to "active_in_#{store}".intern
      end

      it "does not raise an error when called without a store param" do
        expect { @client.send "active_in_#{store}".intern }.should_not raise_error
      end
    end

    describe "#upcoming_in_#{store}" do
      it "generates a dynamic method for the store" do
        @client.should respond_to "upcoming_in_#{store}".intern
      end

      it "does not raise an error when called without a store param" do
        expect { @client.send "upcoming_in_#{store}".intern }.should_not raise_error
      end
    end
  end

end