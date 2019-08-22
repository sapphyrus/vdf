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
       user       system     total    real
vdf    0.016000   0.000000   0.016000 (  0.012664)
vdf4r  0.391000   0.000000   0.391000 (  0.383975)
```

Large VDF File (CS:GO's items_game.txt)
```
      user        system    total     real
vdf   1.328000    0.047000   1.375000 (  1.418189)
vdf4r 50.328000   0.031000  50.359000 ( 50.757693)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/vdf.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
