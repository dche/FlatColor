
import XCTest
import FlatUtil
@testable import FlatColor

class SrgbTests: XCTestCase {

    func testRgbConversion() {
        XCTAssert(quickCheck(Gen<Srgb>(), size: 100) { (clr: Srgb) in
            let c = Srgb(rgb: clr.rgbColor)
            return c.isClose(to: clr, tolerance: 0.1)
        })
    }
}
