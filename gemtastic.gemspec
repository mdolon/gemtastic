lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gemtastic/version"

Gem::Specification.new do |spec|
  spec.name = "gemtastic"
  spec.version = Gemtastic::VERSION
  spec.authors = ["Monji Dolon"]
  spec.email = ["mdolon@gmail.com"]
  spec.description = "Tired of staring at your Gemfile trying to remember what each gem does? Use Gemtastic to add annotations taken from RubyGems.org."
  spec.summary = "A Ruby Gem to clean and annotate your Gemfiles."
  spec.homepage = "https://github.com/mdolon/gemtastic"
  spec.license = "MIT"

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "slop"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
