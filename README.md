# VDF

VDF is a gem to convert Valve's KeyValue format to ruby hashes and back, based on the excellent [node-steam/vdf](https://github.com/node-steam/vdf)

[![Build Status](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fsapphyrus%2Fvdf%2Fbadge&style=popout)](https://actions-badge.atrox.dev/sapphyrus/vdf/goto)
[![Gem](https://img.shields.io/gem/v/vdf?color=%23E9573F)](https://rubygems.org/gems/vdf)

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

Parsing a VDF file is simple:

```ruby
require "vdf"

# Load VDF file into a string
vdf_contents = File.read("filename.vdf")

# Parse it
parsed = VDF.parse(vdf_contents)

# Pretty-print the result
p parsed

```

Creating one is too:

```ruby
require "vdf"

# Set up hash to generate a VDF from
object = {
	"string" => "string",
	"false" => false,
	"true" => true,
	"number" => 1234,
	"float" => 12.34,
	"null" => nil,
	"nested" => {
		"string" => "string",
		"deep" => {
			"string" => "string"
		}
	}
}

# Generate a VDF string and output it
puts VDF.generate(object)

```

## Performance comparison

Small VDF File
```
      user       system     total     real
vdf    0.015000   0.000000   0.015000 (  0.013349)
vdf4r  0.391000   0.000000   0.391000 (  0.389993)
```

Large VDF File (4MB - CS:GO's items_game.txt)
```
      user       system    total      real
vdf    1.312000   0.031000   1.343000 (  1.348015)
vdf4r 53.422000   0.016000  53.438000 ( 54.020029)
```

Compared to the [vdf4r gem](https://github.com/skadistats/vdf4r) using [this script](https://gist.github.com/sapphyrus/3aab81ad06949c3743ad91e20ccf7c65).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sapphyrus/vdf.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
