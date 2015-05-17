# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'train_track/version'

Gem::Specification.new do |spec|
  spec.name          = "train_track"
  spec.version       = TrainTrack::VERSION
  spec.authors       = ["Anthony Super"]
  spec.email         = ["anthony@noided.media"]


  spec.summary       = %q{Track changes to rails models in a generic way}
  spec.homepage      = "https://github.com/ANthonySUper/train_track"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "codeclimate-test-reporter"
  spec.add_dependency "activesupport", ">= 4.0.0"
end
