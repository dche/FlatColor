
import XCTest
@testable import FlatColor

class RgbTests: XCTestCase {

    func testConstructors() {
        var clr = Rgb(red: 0.5, green: -2, blue: 3)
        XCTAssertEqual(clr.red, 0.5)
        XCTAssertEqual(clr.green, 0)
        XCTAssertEqual(clr.blue, 1)

        clr = Rgb(255, 128, 200)
        XCTAssertEqual(clr.red, 1)
        XCTAssert(clr.green.isClose(to: 0.5, tolerance: 1e-2))
    }

    func testSetComponents() {
        var red = Rgb.red
        red.red = 100
        XCTAssertEqual(red.red, 1)
    }

    func testInterpolatable() {
        let red = Rgb.red
        let green = Rgb.green
        let yellow = red.interpolate(between: green, t: 0.5)
        XCTAssertEqual(yellow, Rgb(red: 0.5, green: 0.5, blue: 0))
    }
}
