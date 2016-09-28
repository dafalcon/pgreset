# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pgreset/version'

Gem::Specification.new do |spec|
  spec.name          = "pgreset"
  spec.version       = Pgreset::VERSION
  spec.authors       = ["Dan Falcone"]
  spec.email         = ["danfalcone@gmail.com"]

  spec.summary       = %q{Automatically kill postgres connections during db:reset}
  spec.description   = %q{Kills postgres connections during db:reset so you don't have to restart your server.  Fixes "database in use" errors.}
  spec.homepage      = "https://github.com/falconed/pgreset"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end
