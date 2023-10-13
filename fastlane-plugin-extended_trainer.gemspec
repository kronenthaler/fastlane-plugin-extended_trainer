lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/extended_trainer/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-extended_trainer'
  spec.version       = Fastlane::ExtendedTrainer::VERSION
  spec.author        = 'kronenthaler'
  spec.email         = 'kronenthaler@gmail.com'

  spec.summary       = 'Extends the functionality of the stock Trainer action'
  spec.homepage      = "https://github.com/kronenthaler/fastlane-plugin-extended_trainer"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 2.7'

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  # spec.add_dependency 'your-dependency', '~> 1.0.0'

  spec.add_development_dependency('bundler')
  spec.add_development_dependency('fastlane')
  spec.add_development_dependency('pry')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec_junit_formatter')
  spec.add_development_dependency('rubocop', '1.50.2')
  spec.add_development_dependency('rubocop-performance')
  spec.add_development_dependency('rubocop-require_tools')
  spec.add_development_dependency('simplecov')
end
