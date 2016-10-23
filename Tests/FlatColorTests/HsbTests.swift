
import XCTest
import FlatUtil
import GLMath
@testable import FlatColor

class HsbTests: XCTestCase {

    func testHue() {
        XCTAssertEqual(Hsb(rgb: .red).hue, 0)
        print(Hsb(rgb: .green).hue)
        XCTAssert(Hsb(rgb: .green).hue.isClose(to: radians(120), tolerance: 0.1))
        XCTAssert(Hsb(rgb: .blue).hue.isClose(to: radians(240), tolerance: 0.1))
    }

    func testSaturation() {
        XCTAssertEqual(Hsb(rgb: .lightGray).saturation, 0)
        XCTAssertEqual(Hsb(rgb: .green).saturation, 1)
    }

    func testBrightness() {
        XCTAssertEqual(Hsb(rgb: .white).brightness, 1)
        XCTAssertEqual(Hsb(rgb: .black).brightness, 0)
    }

    func testRgbConversion() {
        XCTAssert(quickCheck(Gen<Hsb>(), size: 1000) { hsb in
            let clr = Hsb(rgb: hsb.rgbColor)
            return clr.isClose(to: hsb, tolerance: 0.1)
        })
        XCTAssert(Hsb(rgb: .white).rgbColor == .white)
        XCTAssert(Hsb(rgb: .black).rgbColor == .black)
    }
}
