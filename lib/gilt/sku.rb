autoload :Money, "money"
module Gilt
  class Sku

    CURRENCY = "USD"
    FOR_SALE = "for sale"
    RESERVED = "reserved"
    SOLD_OUT = "sold out"

    def initialize(sku_response)
      @sku = sku_response
    end

    def id
      @sku["id"].to_i
    end

    def inventory_status
      @sku["inventory_status"]
    end

    def for_sale?
      inventory_status == FOR_SALE
    end

    def sold_out?
      inventory_status == SOLD_OUT
    end

    def reserved?
      inventory_status == RESERVED
    end

    def msrp_price
      to_dollars @sku["msrp_price"]
    end

    def sale_price
      to_dollars @sku["sale_price"]
    end

    def shipping_surcharge
      surcharge = @sku["shipping_surcharge"]
      to_dollars surcharge.nil? ? 0 : surcharge
    end

    def subtotal
      sale_price + shipping_surcharge
    end

    def attributes
      pairs = @sku["attributes"].map do |pair|
        [pair["name"].intern, pair["value"]]
      end
      Hash[pairs]
    end

    def sale?
      sale_price != msrp_price
    end

    private

    def to_dollars(price)
      ::Money.from_string(price, CURRENCY)
    end
  end
end