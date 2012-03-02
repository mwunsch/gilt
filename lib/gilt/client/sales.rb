require "gilt/client"

module Gilt
  class Client
    class Sales < Gilt::Client
      WOMEN = :women
      MEN   = :men
      KIDS  = :kids
      HOME  = :home

      domain DOMAIN

      required :apikey

      optional :affid

      get :active, "/sales/active.#{FORMAT}"

      get :active_in_store, "/sales/:store/active.#{FORMAT}"

      get :upcoming, "/sales/upcoming.#{FORMAT}"

      get :upcoming_in_store, "/sales/:store/upcoming.#{FORMAT}"

      get :detail, "/sales/:store/:sale_key/detail.#{FORMAT}"
    end
  end
end