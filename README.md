# API Versioner

API Versioner is a tiny focused gem that provides support for semantic versioning to API apps. The idea is as follows:

- Backend has its current API version that it exposes in the `X-API-Server-Version` response header by default
- Client requests a certain API version by sending it in the `X-API-Client-Version` request header by default
- Before processing the request, backend checks the requested version against the current version using some policy and terminates with an error if the version is unsupported.

All moving parts (headers names, the policy and the handler) are configurable.

## Middlewares

During initialization if the gem sees it's used in a Rails app, it installs two middlewares:
- `ApiVersioner::ServerVersionMiddleware` places the current version in the response header (defaults to `X-API-Server-Version`). The header name and the current version is configurable.
- `ApiVersioner::ClientVersionMiddleware` analyzes the version in the said request header (defaults to `X-API-Client-Version`) and checks it against the current server version using a specified policy.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'api_versioner'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install versioner

## Usage

```ruby
# config/initializers/versioner.rb

Versioner.configure do |config|
  # Current version of the application
  config.current_version = '1.2.3'

  # The name of the header to set the current server API version
  # Default: 'X-API-Server-Version'
  config.server_version_header = 'X-API-Server-Version'

  # The header to look for the API version required by the client
  # Default: 'X-API-Client-Version'
  config.client_version_header = 'X-API-Client-Version'

  # A callable object to check version policy. It's called with current server version
  # and the requested version from the request header (`client_version_header`).
  # If the requested version is unsupported, the `ApiVersioner::UnsupportedVersion` error should be raised.
  config.version_policy = ApiVersioner::DefaultPolicy.new

  # A callable object to handle the `ApiVersioner::UnsupportedVersion` error in a way
  # specific to your application. It's called with the error and the configuration.
  # The default implementation renders JSON like below and returns it with error code 400.
  config.unsupported_version_handler = ApiVersioner::DefaultHandler.new
end
```

## Policy

A policy is a callable object with two arguments, like below:

```ruby
class CustomPolicy
  def call(current_version, requested_version)
    raise ApiVersioner::UnsupportedVersion, "This version is ..." if some_condition?
  end
end
```

A policy should raise the `ApiVersioner::UnsupportedVersion` error if the requested version is unsupported.

The default implementation (`ApiVersioner::DefaultPolicy`) passes for:
- unspecified versions
- equal versions
- requested versions that are lower than current on minor and/or patch levels

Raises errors for:
- requested versions that are **lower than current on major level**
- requested versions that are higher than current

## UnsupportedVersion error

`ApiVersioner::UnsupportedVersion` error has `reason` field that is not initialized by default. You can initialize it with your own value as necessary. This value is returned in the error meta-section by the `ApiVersioner::DefaultHandler` as shown in the next section.

## Handler

The handler is a callable object that generates the response when an unsupported version is detected.

```ruby
class CustomHandler
  def call(error, config)
    [200, {}, ['Version error']]
  end
end
```

The default implementation (`ApiVersioner::DefaultHandler`):
- Returns status 400 (Bad Request)
- Renders JSON content as follows:

```json
{
  "errors": [
    {
      "title": "Error message ...",
      "status": 400,
      "code": "UNSUPPORTED_VERSION",
      "meta": {
        "reason": <error.reason>
      }
    }
  ]
}
```

Default policy reason codes are:
- `TOO_LOW` - major number of the requested version is lower than current
- `TOO_HIGH` - requested version is higher than current on any level

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/versioner. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/versioner/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
