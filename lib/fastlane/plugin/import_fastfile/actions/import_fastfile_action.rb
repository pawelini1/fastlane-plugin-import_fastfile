require 'fastlane/action'
require_relative '../helper/import_fastfile_helper'

module Fastlane
  module Actions
    class ImportFastfileAction < Action
      def self.run(params)
        require 'open-uri'
        require 'fileutils'

        if not gitRawUrl = params[:gitRawUrl] || ENV['IMPORT_FASTFILE_GIT_RAW_URL'] then UI.user_error!("[import_fastfile] Cannot import Fastfile due to missing 'gitRawUrl' value or 'IMPORT_FASTFILE_GIT_RAW_URL' environment variable.") end

        fastfile = params[:into]
        files = params[:files]

        files.each do |file|
          if not path = file[:path] then UI.user_error!("[import_fastfile] Cannot import Fastfile due to missing 'path' value in #{file}") end
          if not version = file[:version] then UI.user_error!("[import_fastfile] Cannot import Fastfile due to missing 'version' value in #{file}") end

          url = "#{gitRawUrl}/#{version}/#{path}"
          import_filename = "#{version.gsub(/[^0-9a-zA-Z-]/i, '_')}/#{URI(url).path.split('/').last}"
          import_path = File.expand_path("#{FastlaneCore::FastlaneFolder.path}imports/#{import_filename}")

          begin
            puts "Downloading: #{url}"
            download = open(url)
            FileUtils.mkdir_p File.dirname(import_path)
            IO.copy_stream(download, import_path)
          rescue StandardError => e
            UI.user_error!("[import_fastfile] Cannot download or save Fastfile due to: '#{e}'")
          end

          begin
            puts "  Importing: #{import_path}"
            fastfile.import(import_path)
          rescue StandardError => e
            UI.user_error!("[import_fastfile] Cannot import Fastfile '#{import_path}' due to: '#{e}'")
          end
        end
      end

      def self.description
        "Imports Fastfiles from shared repository"
      end

      def self.authors
        ["Paweł Szymański"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Imports Fastfile from shared repository"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :into,
                               description: "Reference to Fastfile object",
                                  optional: false,
                                 is_string: false,
                                      type: Fastlane::FastFile),
          FastlaneCore::ConfigItem.new(key: :files,
                               description: "Array of Hash'es containing :path and :version",
                                  optional: false,
                                 is_string: false,
                                      type: Array),
          FastlaneCore::ConfigItem.new(key: :gitRawUrl,
                               description: "Git 'raw' URL prefix defining repository used to store Fastfiles",
                                  optional: true,
                                 is_string: true,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
