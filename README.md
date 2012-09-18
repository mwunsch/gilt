      .oooooo.     ooooo   ooooo     ooooooooooooo
     d8P'  `Y8b    `888'   `888'     8'   888   `8
    888             888     888           888
    888             888     888           888
    888     ooooo   888     888           888
    `88.    .88'    888     888     o     888
     `Y8bood8P'    o888o   o888ooood8    o888o


`gilt` is a Ruby library for v1 of the [Gilt Public API](http://dev.gilt.com/).

It's written with the [Weary](https://github.com/mwunsch/weary) framework, so it gets the features of that library out of the box, like:

* Full Rack integration. The Client to the library is a Rack application.
* Fully asynchronous. `gilt` makes liberal use of futures and Weary::Deferred.

[![Build Status](https://secure.travis-ci.org/mwunsch/gilt.png)](http://travis-ci.org/mwunsch/gilt) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/mwunsch/gilt)

* [Gilt on RubyGems.org](https://rubygems.org/gems/gilt)
* [Gilt on RubyDoc.info](http://rubydoc.info/github/mwunsch/gilt/)
* [Gilt on Travis CI](http://travis-ci.org/#!/mwunsch/gilt)
* [Gilt on Code Climate](https://codeclimate.com/github/mwunsch/gilt)

## Examples

```ruby
active_sales = Gilt::Sale.active :apikey => "your-api-key"
womens_sales = sales.select {|sale| sale.store == Gilt::Stores::WOMEN }
sales.first.products.map(&:name)
```

Above, the call to `sales.products` returns a list of [Weary::Deferred](https://github.com/mwunsch/weary/blob/master/lib/weary/deferred.rb) objects wrapping Gilt::Product objects. This means that fetching the product is asynchronous, and only blocks when accessed.

Get a list of active Sales:

```ruby
Gilt::Sale.active :apikey => "your-api-key", :affid => "your-affiliate-id"
```

Get a list of active Sales in a particular store:

```ruby
Gilt::Sale.active_in_store :apikey => "your-api-key", :affid => "your-affiliate-id", :store => Gilt::Stores::WOMEN
```

Or upcoming sales:

```ruby
Gilt::Sale.upcoming :apikey => "your-api-key", :affid => "your-affiliate-id"
```

Get a particular sale:

```ruby
Gilt::Sale.detail :apikey => "your-key", :store => Gilt::Stores::WOMEN, :sale_key => "m-missoni-5228"
```

Here's a fun one, for all active sales in the Women store, create a hash of `Sale Name => [Product Name,...]`:

```ruby
require "pp"

active_sales = Gilt::Sale.active_in_store :apikey => "my-api-key", :store => Gilt::Stores::WOMEN
pp Hash[active_sales.map {|sale| [sale.name, sale.products.map(&:name)] }] # This could take a while
```

### With Rack

Since Gilt is built on Weary (which in turn is built on [Rack](http://rack.github.com/)), you can quickly create a proxy to the Gilt API and insert whatever middleware your heart desires.

```ruby
# config.ru
client = Gilt::Client::Product
client.use Rack::Runtime

run client
```

After `rackup`:

    curl "http://localhost:9292/sales/active.json?apikey=my-api-key"

## Installation

    gem install gilt

## Copyright

Copyright (c) 2012 Mark Wunsch. Licensed under the [MIT License](http://opensource.org/licenses/mit-license.php).
