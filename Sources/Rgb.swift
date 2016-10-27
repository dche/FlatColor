//
// FlatColor - Rgb.swift
//
// RGB color model.
//
// Copyright (c) 2016 The FlatColor authors.
// Licensed under MIT License.

import simd
import FlatUtil
import GLMath

/// Color value in RGB color model.
public struct Rgb {

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
        self._rgba = clamp(rgba, 0, 1)
    }

    public init (red: Float, green: Float, blue: Float, alpha: Float = 1) {
        self.init(vec4(red, green, blue, alpha))
    }

    public init (_ r: UInt8, _ g: UInt8, _ b: UInt8, _ a: UInt8 = 255) {

        func u2f(_ x: UInt8) -> Float {
            switch x {
            case 0xFF: return 1.0
            default: return Float(x) * Float.one_over_255
            }
        }

        var rgba = vec4.zero
        rgba.x = u2f(r)
        rgba.y = u2f(g)
        rgba.z = u2f(b)
        rgba.w = u2f(a)

        self._rgba = rgba
    }

    // TODO: Rgb("#e9c"), Rgb("#e292c2")
}

extension Rgb: Color {

    public init (rgb: Rgb) {
        self = rgb
    }

    public var rgbColor: Rgb { return self }

    public var vector: vec4 { return self._rgba }
}

extension Rgb: Random {

    public init (withRng rng: inout Rng) {
        self.init(vec4(vec3(withRng: &rng), 1))
    }
}

extension Rgb: Zero {

    public static let zero = Rgb(vec4.zero)

    public static func + (lhs: Rgb, rhs: Rgb) -> Rgb {
        return Rgb(lhs.vector + rhs.vector)
    }
}

extension Rgb: Interpolatable {

    public func interpolate(between y: Rgb, t: Float) -> Rgb {
        return Rgb(mix(self.vector, y.vector, t))
    }
}

extension Rgb: CustomStringConvertible {

    public var description: String {
        return "Rgb(red: \(self.red), green: \(self.green), blue: \(self.blue), alpha: \(self.alpha))"
    }
}

extension Rgb {

    public static func * (lhs: Rgb, rhs: Float) -> Rgb {
        return Rgb(lhs.vector * rhs)
    }

    /// The luminance of a RGB color.
    public var luminance: Float {
        let v = self.vector
        return dot(vec3(v.x, v.y, v.z), vec3(0.2126, 0.7152, 0.0722))
    }

    /// Constructs a gray color.
    public static func gray(degree: Float) -> Rgb {
        return Rgb(vec4(vec3(degree), 1))
    }
}
