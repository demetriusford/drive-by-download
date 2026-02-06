# frozen_string_literal: true

require_relative "lib/dbd/version"

Gem::Specification.new do |spec|
  spec.name          = "dbd"
  spec.version       = Dbd::VERSION
  spec.authors       = ["Demetrius Ford"]

  spec.summary       = "Drive-by download payload generator for security testing"
  spec.description   = "A CLI tool for generating obfuscated JavaScript payloads that trigger " \
    "automatic file downloads in browsers. Designed for authorized penetration " \
    "testing, red team operations, and security research."
  spec.homepage      = "https://github.com/demetriusford/drive-by-download-ruby"
  spec.license       = "Apache-2.0"
  spec.required_ruby_version = ">= 3.1.0"

  spec.files         = Dir["lib/**/*.rb", "bin/*", "templates/*", "README.md", "LICENSE"]
  spec.bindir        = "bin"
  spec.executables   = ["dbd"]
  spec.require_paths = ["lib"]

  spec.add_dependency("base64", "~> 0.2")
  spec.add_dependency("thor", "~> 1.3")

  spec.add_development_dependency("rspec", "~> 3.13")
  spec.add_development_dependency("rubocop-shopify", "~> 2.15")

  spec.metadata["rubygems_mfa_required"] = "true"
  spec.metadata["allowed_push_host"] = ""
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["homepage_uri"] = spec.homepage
end
