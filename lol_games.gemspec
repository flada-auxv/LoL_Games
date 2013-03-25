# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lol_games/version'

Gem::Specification.new do |spec|
  spec.name          = "lol_games"
  spec.version       = LolGames::VERSION
  spec.authors       = ["flada-auxv"]
  spec.email         = ["aseknock@gmail.com"]
  spec.description   = %q{Land of Lisp's game by ruby}
  spec.summary       = %q{game}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = ["lol_games"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "hashie"
end
