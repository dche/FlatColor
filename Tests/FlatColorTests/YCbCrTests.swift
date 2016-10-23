
import XCTest
import FlatUtil
@testable import FlatColor

class YCbCrTests: XCTestCase {

    func testRgbConversion() {
        XCTAssert(quickCheck(Gen<YCbCr>(), size: 100) { (clr: YCbCr) in
            let c = YCbCr(rgb: clr.rgbColor)
            return c.isClose(to: clr, tolerance: 0.1)
        })
    }
}
