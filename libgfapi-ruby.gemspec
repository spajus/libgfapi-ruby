# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'glusterfs/version'

Gem::Specification.new do |spec|
  spec.name          = "libgfapi-ruby"
  spec.version       = GlusterFS::VERSION
  spec.authors       = ["Tomas Varaneckas"]
  spec.email         = ["tomas.varaneckas@gmail.com"]
  spec.summary       = %q{Ruby bindings for libgfapi (GlusterFS API)}
  spec.description   = %q{Ruby bindings for libgfapi (GlusterFS API)}
  spec.homepage      = "https://github.com/spajus/libgfapi-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "ffi", "~> 1.9"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "ruby-mass"
end
