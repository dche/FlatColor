
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

    func testUInt32Constructor() {
        var clr = Rgb(0)
        XCTAssertEqual(clr, Rgb.clearColor)
        clr = Rgb(0xFF)
        XCTAssertEqual(clr, Rgb.black)
        clr = Rgb(0xFFFFFFFF)
        XCTAssertEqual(clr, Rgb.white)
        clr = Rgb(0xFFFF00FF)
        XCTAssertEqual(clr, Rgb.yellow)
    }

    func testCSSStringConstructor() {
        // Invalid.
        var clr = Rgb("123")
        XCTAssertEqual(clr, Rgb.black)
        clr = Rgb("#1234")
        XCTAssertEqual(clr, Rgb.black)
        clr = Rgb("#TCC")
        XCTAssertEqual(clr, Rgb.black)
        // Valid
        clr = Rgb("#Ff0")
        XCTAssertEqual(clr, Rgb.yellow)
        clr = Rgb("#ffff00")
        XCTAssertEqual(clr, Rgb.yellow)
    }

    func testSetComponents() {
        var red = Rgb.red
        red.red = 100
        XCTAssertEqual(red.red, 1)
    }

    func testInterpolatable() {
        let red = Rgb.red
        let green = Rgb.green
        let yellow = red.interpolate(green, t: 0.5)
        XCTAssertEqual(yellow, Rgb(red: 0.5, green: 0.5, blue: 0))
    }
}
