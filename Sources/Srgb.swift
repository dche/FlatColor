//
// FlatColor - Srgb
//
// Copyright (c) 2016 The FlatColor authors.
// Licensed under MIT License.

import simd
import FlatUtil
import GLMath

/// The sRGB color space.
public struct Srgb {

    fileprivate var _rgba: vec4

    /// The red component.
    public var red: Float {
        get { return _rgba.x }
        set { _rgba.x = clamp(newValue, 0, 1) }
    }

    /// The green component.
    public var green: Float {
        get { return _rgba.y }
        set { _rgba.y = clamp(newValue, 0, 1) }
    }

    ///  The blue component.
    public var blue: Float {
        get { return _rgba.z }
        set { _rgba.z = clamp(newValue, 0, 1) }
    }

    /// The alpha component.
    public var alpha: Float {
        get { return _rgba.w }
        set { _rgba.w = clamp(newValue, 0, 1) }
    }

    init(_ rgba: vec4) {
        self._rgba = rgba
    }

}

extension Srgb: Color {

    public init (rgb: Rgb) {
        let v3 = rgb.vector.rgb.map { f in
            guard f > 0.0031308 else { return f * 12.92 }

            let a: Float = 0.055
            return (a + 1) * pow(f, recip(2.4)) - a
        }
        self.init(vec4(v3, rgb.alpha))
    }

    public var rgbColor: Rgb {
        let v3 = self.vector.rgb.map { f in
            guard f > 0.04045 else { return f / 12.92 }

            let a: Float = 0.055
            return pow((f + a) * recip(1 + a), 2.4)
        }
        return Rgb(vec4(v3, self.alpha))
    }

    public var vector: vec4 { return self._rgba }
}

extension Srgb: Random {

    public init(withRng rng: inout Rng) {
        self = Srgb(rgb: Rgb(withRng: &rng))
    }
}

extension Srgb: CustomStringConvertible {

    public var description: String {
        return "Srgb(r: \(self.red), g: \(self.green), b: \(self.blue), alpha: \(self.alpha))"
    }
}
