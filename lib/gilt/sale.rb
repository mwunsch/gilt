module Gilt
  class Sale
    def self.client(apikey, affid=nil)
      Gilt::Client::Sales.new(apikey, affid)
    end

  end
end