describe Fastlane::ExtendedTrainer do
  describe Fastlane::ExtendedTrainer::TestParser do
    describe "Loading a file" do
      it "raises an error if the file doesn't exist" do
        expect do
          Fastlane::ExtendedTrainer::TestParser.new("notExistent")
        end.to raise_error(/File not found at path/)
      end

      it "raises an error if FormatVersion is not supported" do
        expect do
          Fastlane::ExtendedTrainer::TestParser.new("./spec/fixtures/InvalidVersionMismatch.plist")
        end.to raise_error("Format version '0.9' is not supported, must be 1.1, 1.2")
      end

      it "loads a file without throwing an error" do
        Fastlane::ExtendedTrainer::TestParser.new("./spec/fixtures/Valid1.plist")
      end
    end

    describe "#auto_convert" do
      it "raises an error if no files were found" do
        expect do
          Fastlane::ExtendedTrainer::TestParser.auto_convert({ path: "bin" })
        end.to raise_error("No test result files found in directory 'bin', make sure the file name ends with 'TestSummaries.plist' or '.xcresult'")
      end
    end

    describe "Stores the data in a useful format" do
      describe "#tests_successful?" do
        it "returns false if tests failed" do
          tp = Fastlane::ExtendedTrainer::TestParser.new("./spec/fixtures/Valid1.plist")
          expect(tp.tests_successful?).to eq(false)
        end
      end

      it "works as expected with plist" do
        tp = Fastlane::ExtendedTrainer::TestParser.new("./spec/fixtures/Valid1.plist")
        expect(tp.data).to eq([
                                {
                                  project_path: "Trainer.xcodeproj",
                                  target_name: "Unit",
                                  test_name: "Unit",
                                  duration: 0.4,
                                  tests: [
                                    {
                                      identifier: "Unit/testExample()",
                                      test_group: "Unit",
                                      name: "testExample()",
                                      object_class: "IDESchemeActionTestSummary",
                                      status: "Success",
                                      guid: "6840EEB8-3D7A-4B2D-9A45-6955DC11D32B",
                                      duration: 0.1
                                    },
                                    {
                                      identifier: "Unit/testExample2()",
                                      test_group: "Unit",
                                      name: "testExample2()",
                                      object_class: "IDESchemeActionTestSummary",
                                      status: "Failure",
                                      guid: "B2EB311E-ED8D-4DAD-8AF0-A455A20855DF",
                                      duration: 0.1,
                                      failures: [
                                        {
                                          file_name: "/Users/liamnichols/Code/Local/Trainer/Unit/Unit.swift",
                                          line_number: 19,
                                          message: "XCTAssertTrue failed - ",
                                          performance_failure: false,
                                          failure_message: "XCTAssertTrue failed -  (/Users/liamnichols/Code/Local/Trainer/Unit/Unit.swift:19)"
                                        }
                                      ]
                                    },
                                    {
                                      identifier: "Unit/testPerformanceExample()",
                                      test_group: "Unit",
                                      name: "testPerformanceExample()",
                                      object_class: "IDESchemeActionTestSummary",
                                      status: "Success",
                                      guid: "72D0B210-939D-4751-966F-986B6CB2660C",
                                      duration: 0.2
                                    }
                                  ],
                                  number_of_tests: 3,
                                  number_of_failures: 1,
                                  number_of_tests_excluding_retries: 3,
                                  number_of_failures_excluding_retries: 1,
                                  number_of_retries: 0
                                }
                              ])
      end

      it "works as expected with xcresult", requires_xcode: true do
        tp = Fastlane::ExtendedTrainer::TestParser.new("./spec/fixtures/Test.test_result.xcresult")
        expect(tp.data).to eq([
                                {
                                  project_path: "Test.xcodeproj",
                                  target_name: "TestUITests",
                                  test_name: "TestUITests",
                                  configuration_name: "Test Scheme Action",
                                  destination_name: "iPhone 6 - 10.3",
                                  destination_os_version: "10.3.1",
                                  duration: 16.05245804786682,
                                  tests: [
                                    {
                                      identifier: "TestUITests.testExample()",
                                      name: "testExample()",
                                      duration: 16.05245804786682,
                                      status: "Success",
                                      test_group: "TestUITests",
                                      guid: ""
                                    }
                                  ],
                                  number_of_tests: 1,
                                  number_of_failures: 0,
                                  number_of_skipped: 0,
                                  number_of_tests_excluding_retries: 1,
                                  number_of_failures_excluding_retries: 0,
                                  number_of_retries: 0
                                },
                                {
                                  project_path: "Test.xcodeproj",
                                  target_name: "TestThisDude",
                                  test_name: "TestThisDude",
                                  configuration_name: "Test Scheme Action",
                                  destination_name: "iPhone 6 - 10.3",
                                  destination_os_version: "10.3.1",
                                  duration: 0.5279300212860107,
                                  tests: [
                                    {
                                      identifier: "TestTests.testExample()",
                                      name: "testExample()",
                                      duration: 0.0005381107330322266,
                                      status: "Success",
                                      test_group: "TestTests",
                                      guid: ""
                                    },
                                    {
                                      identifier: "TestTests.testFailureJosh1()",
                                      name: "testFailureJosh1()",
                                      duration: 0.006072044372558594,
                                      status: "Failure",
                                      test_group: "TestTests",
                                      guid: "",
                                      failures: [
                                        {
                                          file_name: "",
                                          line_number: 0,
                                          message: "",
                                          performance_failure: {},
                                          failure_message: "XCTAssertTrue failed (/Users/josh/Projects/fastlane/test-ios/TestTests/TestTests.swift#CharacterRangeLen=0&EndingLineNumber=36&StartingLineNumber=36)"
                                          }
                                      ]
                                    },
                                    {
                                      identifier: "TestTests.testPerformanceExample()",
                                      name: "testPerformanceExample()",
                                      duration: 0.2661939859390259,
                                      status: "Success",
                                      test_group: "TestTests",
                                      guid: ""
                                    },
                                    {
                                      identifier: "TestThisDude.testExample()",
                                      name: "testExample()",
                                      duration: 0.0004099607467651367,
                                      status: "Success",
                                      test_group: "TestThisDude",
                                      guid: ""
                                    },
                                    {
                                      identifier: "TestThisDude.testFailureJosh2()",
                                      name: "testFailureJosh2()",
                                      duration: 0.001544952392578125,
                                      status: "Failure",
                                      test_group: "TestThisDude",
                                      guid: "",
                                      failures: [
                                        {
                                          file_name: "",
                                          line_number: 0,
                                          message: "",
                                          performance_failure: {},
                                          failure_message: "XCTAssertTrue failed (/Users/josh/Projects/fastlane/test-ios/TestThisDude/TestThisDude.swift#CharacterRangeLen=0&EndingLineNumber=35&StartingLineNumber=35)"
                                        }
                                      ]
                                    },
                                    {
                                      identifier: "TestThisDude.testPerformanceExample()",
                                      name: "testPerformanceExample()",
                                      duration: 0.2531709671020508,
                                      status: "Success",
                                      test_group: "TestThisDude",
                                      guid: ""
                                    }
                                  ],
                                  number_of_tests: 6,
                                  number_of_failures: 2,
                                  number_of_skipped: 0,
                                  number_of_tests_excluding_retries: 6,
                                  number_of_failures_excluding_retries: 2,
                                  number_of_retries: 0
                                }
                              ])
      end
    end
  end
end
