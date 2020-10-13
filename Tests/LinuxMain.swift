import XCTest

import ScreenshotsTests

var tests = [XCTestCaseEntry]()
tests += ScreenshotsTests.allTests()
tests += UIImageTests.allTests()
XCTMain(tests)
