# Versioner

Versioner is a tiny focused gem that provides support for semantic versioning to Rails apps. It installs two middlewares:
- `Versioner::ServerVersionMiddleware` places the current version in the response header (defaults to `X-API-Server-Version`). The header name and the current version is configurable.
- `Versioner::ClientVersionMiddleware` analyzes the version in the said request header (defaults to `X-API-Client-Version`) and checks it against the current server version using a specified policy.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'versioner'
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

  # The name of the header to set the server version number
  # Default: 'X-API-Server-Version'
  config.server_version_header = 'X-API-Server-Version'

  # The header to look for the client version number
  # Default: 'X-API-Client-Version'
  config.client_version_header = 'X-API-Client-Version'

  # A callable object to check version policy. It's called with current server version
  # and the client version from the request header (`client_version_header`). If two
  # versions are incompatible, the `Versioner::IncompatibleVersion` error should be raised.
  config.version_policy = Versioner::DefaultPolicy.new

  # A callable object to handle the `Versioner::IncompatibleVersion` error in a way
  # specific to your application. It's called with the error and the configuration.
  # The default implementation renders JSON like below and returns it with error code 400.
  config.incompatible_version_handler = Versioner::DefaultHandler.new
end
```

## Policy

A policy is a callable object with two arguments, like below:

```ruby
class CustomPolicy
  def call(server_version, client_version)
    raise Versioner::IncompatibleVersion, "This version is ..." if some_condition?
  end
end
```

A policy should raise the `Versioner::IncompatibleVersion` error if the requested client version is incompatible with the current server version.

The default implementation (`Versioner::DefaultPolicy`):
- ignores unspecified versions
- raises an error if the major numbers differ
- raises an error if the client version is greater than the current server version

## Handler

The handler is a callable object that generates the response when an incompatible version is detected.

```ruby
class CustomHandler
  def call(error, config)
    [200, {}, ['Version error']]
  end
end
```

The default implementation (`Versioner::DefaultHandler`):
- Returns status 400 (Bad Request)
- Renders JSON content as follows:

```json
{
  "errors": [
    {
      "title": "Error message ...",
      "status": 400,
      "code": "UNSUPPORTED_VERSION"
    }
  ]
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/versioner. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/versioner/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
