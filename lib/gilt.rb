module Gilt
  module Stores
    WOMEN = :women
    MEN   = :men
    KIDS  = :kids
    HOME  = :home
  end

  autoload :Sale, 'gilt/sale'
  autoload :Product, 'gilt/product'
end

require "gilt/client"
require "gilt/version"
