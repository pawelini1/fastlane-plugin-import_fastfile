describe Fastlane::Actions::ImportFastfileAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The import_fastfile plugin is working!")

      Fastlane::Actions::ImportFastfileAction.run(nil)
    end
  end
end
