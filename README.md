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

## Examples

```ruby
active_sales = Gilt::Sale.active :apikey => "your-api-key"
womens_sales = sales.select {|sale| sale.store == Gilt::Stores::WOMEN }
sales.products.map(&:name)
```

Above, the call to `sales.products` returns a list of [Weary::Deferred](https://github.com/mwunsch/weary/blob/master/lib/weary/deferred.rb) objects wrapping Gilt::Product objects. This means that fetching the product is fully asynchronous, and only blocks when accessed.

### With Rack

```ruby
# config.ru
client = Gilt::Client::Product.new "my-api-key", "my-affiliate-id"
client.use Rack::Runtime

run client
```

After `rackup`:

    curl "http://localhost:9292/sales/active.json"
