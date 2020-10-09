import XCTest
@testable import Screenshots

final class ScreenshotsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Screenshots().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
