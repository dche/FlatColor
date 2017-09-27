import XCTest
@testable import FlatColorTests

extension HsbTests {
    static let allTests: [(String, (HsbTests) -> () throws -> ())] = [
        ("testHue", testHue),
        ("testSaturation", testSaturation),
        ("testBrightness", testBrightness),
        ("testRgbConversion", testRgbConversion),
    ]
}

extension RgbTests {
    static let allTests: [(String, (RgbTests) -> () throws -> ())] = [
        ("testConstructors", testConstructors),
        ("testUInt32Constructor", testUInt32Constructor),
        ("testCSSStringConstructor", testCSSStringConstructor),
        ("testSetComponents", testSetComponents),
        ("testInterpolatable", testInterpolatable),
    ]
}

extension SrgbTests {
    static let allTests: [(String, (SrgbTests) -> () throws -> ())] = [
        ("testRgbConversion", testRgbConversion),
    ]
}

extension YCbCrTests {
    static let allTests: [(String, (YCbCrTests) -> () throws -> ())] = [
        ("testRgbConversion", testRgbConversion),
    ]
}

XCTMain([
    testCase(HsbTests.allTests),
    testCase(RgbTests.allTests),
    testCase(SrgbTests.allTests),
    testCase(YCbCrTests.allTests),
])
