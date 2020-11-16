require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class ImportFastfileHelper
      # class methods that you define here become available in your action
      # as `Helper::ImportFastfileHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the import_fastfile plugin helper!")
      end
    end
  end
end
