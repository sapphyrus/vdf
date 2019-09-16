lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "vdf/version"

Gem::Specification.new do |spec|
  spec.name          = "vdf"
  spec.version       = VDF::VERSION
  spec.authors       = ["sapphyrus"]
  spec.email         = ["phil5686@gmail.com"]

  spec.summary       = %q{Parses Valve's KeyValue format to Ruby Hashes and back}
  spec.homepage      = "https://github.com/sapphyrus/vdf"
  spec.license       = "MIT"

  spec.description   = <<-EOF
    VDF is a gem to convert Valve's KeyValue format to Ruby hashes and create a VDF string from a Ruby hash.
    It's based on the excellent node-steam/vdf JS library and it's optimized for performance
  EOF

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sapphyrus/vdf"
  spec.metadata["bug_tracker_uri"] = "https://github.com/sapphyrus/vdf/issues"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/vdf"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
end
