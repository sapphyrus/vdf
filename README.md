# Vdf

VDF is a gem to convert Valve's KeyValue format to ruby hashes and back, based on the excellent https://github.com/node-steam/vdf

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vdf'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vdf

## Usage

Parsing a VDF is simple:

```ruby
require "vdf"

# Load VDF file into a string
vdf_contents = File.read("filename.vdf")

# Parse it
parsed = VDF.parse(vdf_contents)

# Pretty-print the result
p parsed

```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/vdf.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
