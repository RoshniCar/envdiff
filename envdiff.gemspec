# frozen_string_literal: true

require_relative "lib/envdiff/version"

Gem::Specification.new do |spec|
  spec.name = "envdiff"
  spec.version = Envdiff::VERSION
  spec.authors = ["RoshniCar"]
  spec.email = ["roshnikalai30@gmail.com"]

  spec.summary = "Compare .env files and show differences"
  spec.description = "A minimal CLI tool to compare .env files across environments. Shows missing keys, different values, and helps catch config drift."
  spec.homepage = "https://github.com/RoshniCar/envdiff"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.glob("{bin,lib}/**/*") + %w[README.md LICENSE.txt CHANGELOG.md]
  spec.bindir = "bin"
  spec.executables = ["envdiff"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.0"
end
