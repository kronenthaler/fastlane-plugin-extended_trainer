require 'fastlane/action'
require_relative '../helper/extended_trainer_helper'

module Fastlane
  module Actions
    class ExtendedTrainerAction < Action
      def self.run(params)
        params[:path] = Actions.lane_context[Actions::SharedValues::SCAN_GENERATED_PLIST_FILE] if Actions.lane_context[Actions::SharedValues::SCAN_GENERATED_PLIST_FILE]
        params[:path] ||= Actions.lane_context[Actions::SharedValues::SCAN_DERIVED_DATA_PATH] if Actions.lane_context[Actions::SharedValues::SCAN_DERIVED_DATA_PATH]

        fail_build = params[:fail_build]
        resulting_paths = Fastlane::ExtendedTrainer::TestParser.auto_convert(params)
        resulting_paths.each do |path, test_results|
          UI.test_failure!("Unit tests failed") if fail_build && !test_results[:successful]
        end

        return resulting_paths
      end

      def self.description
        "Extends the functionality of the stock Trainer action"
      end

      def self.authors
        ["kronenthaler"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Add additional fields to the report for better debugging and tracing"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :path,
                                       short_option: "-p",
                                       env_name: "TRAINER_PATH",
                                       default_value: ".",
                                       description: "Path to the directory that should be converted",
                                       verify_block: proc do |value|
                                         v = File.expand_path(value.to_s)
                                         if v.end_with?(".plist")
                                           UI.user_error!("Can't find file at path #{v}") unless File.exist?(v)
                                         else
                                           UI.user_error!("Path '#{v}' is not a directory or can't be found") unless File.directory?(v)
                                         end
                                       end),
          FastlaneCore::ConfigItem.new(key: :extension,
                                       short_option: "-e",
                                       env_name: "TRAINER_EXTENSION",
                                       default_value: ".xml",
                                       description: "The extension for the newly created file. Usually .xml or .junit",
                                       verify_block: proc do |value|
                                         UI.user_error!("extension must contain a `.`") unless value.include?(".")
                                       end),
          FastlaneCore::ConfigItem.new(key: :output_directory,
                                       short_option: "-o",
                                       env_name: "TRAINER_OUTPUT_DIRECTORY",
                                       default_value: nil,
                                       optional: true,
                                       description: "Directory in which the xml files should be written to. Same directory as source by default"),
          FastlaneCore::ConfigItem.new(key: :output_filename,
                                       short_option: "-f",
                                       env_name: "TRAINER_OUTPUT_FILENAME",
                                       default_value: nil,
                                       optional: true,
                                       description: "Filename the xml file should be written to. Defaults to name of input file. (Only works if one input file is used)"),
          FastlaneCore::ConfigItem.new(key: :fail_build,
                                       env_name: "TRAINER_FAIL_BUILD",
                                       description: "Should this step stop the build if the tests fail? Set this to false if you're handling this with a test reporter",
                                       is_string: false,
                                       default_value: true),
          FastlaneCore::ConfigItem.new(key: :xcpretty_naming,
                                       short_option: "-x",
                                       env_name: "TRAINER_XCPRETTY_NAMING",
                                       description: "Produces class name and test name identical to xcpretty naming in junit file",
                                       is_string: false,
                                       default_value: false),
          FastlaneCore::ConfigItem.new(key: :silent,
                                       env_name: "TRAINER_SILENT",
                                       description: "Silences all output",
                                       is_string: false,
                                       default_value: false),
          FastlaneCore::ConfigItem.new(key: :output_remove_retry_attempts,
                                       env_name: "TRAINER_OUTPUT_REMOVE_RETRY_ATTEMPTS",
                                       description: "Doesn't include retry attempts in the output",
                                       is_string: false,
                                       default_value: false)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
