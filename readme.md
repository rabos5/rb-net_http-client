# NetHTTP.client

This gem is not meant to reinvent the wheel but is meant to extend and "simplify", albeit subjective :), Ruby's NetHTTP code from the standard library.  No functionality in the Ruby NetHTTP standard library is being replaced or overwritten; only extended.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rb-net_http-client', source: 'https://rubygems.org/'
```

And then execute:
```
bundle install
```
Or install it yourself as:
```
gem install 'rb-net_http-client'
```
## Usage

Please check out the examples/ directory for sample use cases.

```
require 'rb-net_http-client'
require 'logger'
require 'pp'

logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

net_http_client = NetHTTP.client(
  logger: logger,
  uri: 'https://jsonplaceholder.typicode.com/'
)

response = net_http_client.get(
  path: '/posts'
)

# OR

response = net_http_client.call_web_service(
  method: 'get',
  headers: {},
  path: '/posts'
)

# sample extended methods added...
# attempts to convert the response string response.headers to a Ruby hash with keys as snake_case symbols.
pp response.headers_hash

# attempts to convert the response string response.headers to a Ruby OpenStruct object so dot notation can be used to traverse the response object.
pp response.headers_os
pp response.headers_os.content_type

# attempts to convert the response string response.body to a Ruby Array / Hash object with keys as snake_case symbols.
pp response.body_obj

# attempts to convert the response string response.body to a Ruby OpenStruct object so dot notation can be used to traverse the response object.
pp response.body_os
pp response.body_os[0].title

# attempts to determine if the response string response.body is a valid json, xml, or html string / object.
pp response.valid_json?
pp response.valid_html?
pp response.valid_xml?
```

## Development

TODO: Write development info here...

## Contributing

Bug reports and pull requests are welcome here on this Github repo. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
