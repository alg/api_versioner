# Versioner

Versioner is a tiny focused gem that provides support for semantic versioning to Rails apps.
What it does:
- Places the current version in the header of every response
- Analyzes the version in the headers of incoming responses and takes action according to the simple rules.

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
Versioner.configure do |config|
  # Current version of the application
  config.current_version = '1.2.3'

  # The name of the header to look for the version number
  # Default: 'X-API-SERVER-VERSION'
  config.header_name = 'X-API-SERVER-VERSION'
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/versioner. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/versioner/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
