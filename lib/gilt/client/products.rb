require "gilt/client"

module Gilt
  class Client
    class Products < Gilt::Client
      domain DOMAIN

      required :apikey

      optional :affid

      get :detail, "/products/:product_id/detail.#{FORMAT}"

      get :categories, "/products/categories.#{FORMAT}"
    end
  end
end