require "gilt/client"

module Gilt
  class Client
    class Sales < Gilt::Client
      domain DOMAIN

      required :apikey

      optional :affid

      get :active, "/sales/active.#{FORMAT}"

      get :active_in_store, "/sales/:store/active.#{FORMAT}"

      get :upcoming, "/sales/upcoming.#{FORMAT}"

      get :upcoming_in_store, "/sales/:store/upcoming.#{FORMAT}"

      get :detail, "/sales/:store/:sale_key/detail.#{FORMAT}"

      [ Gilt::Stores::WOMEN,
        Gilt::Stores::MEN,
        Gilt::Stores::KIDS,
        Gilt::Stores::HOME ].each do |store|
        define_method "active_in_#{store}" do |*args, &block|
          params = args.first || {}
          active_in_store params.merge({:store => store}), &block
        end
        alias_method "#{store}_active".intern, "active_in_#{store}".intern

        define_method "upcoming_in_#{store}" do |*args, &block|
          params = args.first || {}
          upcoming_in_store params.merge({:store => store}), &block
        end
        alias_method "#{store}_upcoming".intern, "upcoming_in_#{store}".intern
      end

    end
  end
end
