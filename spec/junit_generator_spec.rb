describe Fastlane::ExtendedTrainer do
  describe Fastlane::ExtendedTrainer::JunitGenerator do
    it "works for a valid .plist file" do
      tp = Fastlane::ExtendedTrainer::TestParser.new("./spec/fixtures/Valid1.plist")
      junit = File.read("./spec/fixtures/Valid1.junit")
      expect(tp.to_junit).to eq(junit)
    end

    it "works for a valid .plist file and xcpretty naming" do
      tp = Fastlane::ExtendedTrainer::TestParser.new("./spec/fixtures/Valid1.plist", { xcpretty_naming: true })
      junit = File.read("./spec/fixtures/Valid1-x.junit")
      expect(tp.to_junit).to eq(junit)
    end

    it "works for a with all tests passing" do
      tp = Fastlane::ExtendedTrainer::TestParser.new("./spec/fixtures/Valid2.plist")
      junit = File.read("./spec/fixtures/Valid2.junit")
      expect(tp.to_junit).to eq(junit)
    end

    it "works for a with all tests passing and xcpretty naming" do
      tp = Fastlane::ExtendedTrainer::TestParser.new("./spec/fixtures/Valid2.plist", { xcpretty_naming: true })
      junit = File.read("./spec/fixtures/Valid2-x.junit")
      expect(tp.to_junit).to eq(junit)
    end

    it "works with an xcresult", requires_xcode: true do
      tp = Fastlane::ExtendedTrainer::TestParser.new("./spec/fixtures/Test.test_result.xcresult")
      junit = File.read("./spec/fixtures/XCResult.junit")
      expect(tp.to_junit.strip).to eq(junit.strip)
    end
  end
end
