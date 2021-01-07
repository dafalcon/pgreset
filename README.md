# pgreset

The pgreset gem makes it possible to run rails db:reset against a postgres database with active connections.  It should eliminate "database in use" errors from rails.

Credit for the [original solution](https://github.com/basecamp/pow/issues/212) goes to [Manuel Meurer](https://github.com/manuelmeurer).

Special thanks to [Emil Kampp](https://github.com/ekampp) and [Michael Yin](https://github.com/layerssss) for adding Rails 6.1 support.

## Installation and Usage

Add this line to your application's Gemfile:

```ruby
gem 'pgreset'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pgreset
    
Now you can run rails db:reset as normal, and rails will kill active connections to the database being reset:

    $ rails db:reset
    

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/falconed/pgreset.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
