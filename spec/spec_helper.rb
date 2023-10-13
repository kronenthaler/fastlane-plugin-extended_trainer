$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'simplecov'

# SimpleCov.minimum_coverage 95
SimpleCov.start

require 'fastlane' # to import the Action super class
require 'fastlane/plugin/extended_trainer' # import the actual plugin

# This module is only used to check the environment is currently a testing env
module SpecHelper
end

Fastlane.load_actions # load other actions (in case your plugin calls other actions or shared values)
