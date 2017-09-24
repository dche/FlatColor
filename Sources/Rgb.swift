//
// FlatColor - Rgb.swift
//
// RGB color model.
//
// Copyright (c) 2017 The FlatColor authors.
// Licensed under MIT License.

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
}

extension Rgb {

    /// Constructs a RGB color with given `UInt32` number, which contains the
    /// values of 4 color channels in the order `RGBA`.
    public init (_ components: UInt32) {
        var c = components.littleEndian
        // SWIFT BUG: Using `UnsafePointer` results to "ambiguous use of `init`"
        //            error.
        self = UnsafeMutablePointer(&c).withMemoryRebound(to: UInt8.self, capacity: 4) { ptr in
            return Rgb(ptr[3], ptr[2], ptr[1], ptr[0])
        }
    }

    /// Constructs a RGB color with given CSS style color string.
    ///
    /// The string must be in the format `"#FFF"` or `#FFFFFF`.
    ///
    /// If the format is invalid, the result color is _black_.
    public init (_ css: String) {

        func hex(char: CChar) -> Int {
            // [0 - 9]
            if char > 47 && char < 58 { return Int(char) - 48 }
            // [A - F]
            if char > 64 && char < 71 { return Int(char) - 65 + 10 }
            // [a - f]
            if char > 96 && char < 103 { return Int(char) - 97 + 10 }
            // Invalid.
            return -1
        }

        let cstr = css.utf8CString
        var rgb = [0, 0, 0]
        // NOTE:
        // - `cstr` contains the trailing `\0` which we do not touch.
        // - ASCII('#') == 35
        if (cstr.count == 5 || cstr.count == 8) && cstr[0] == 35 {
            for i in 0..<3 {
                if cstr.count == 5 {
                    let n = hex(char: cstr[i + 1])
                    guard n >= 0 else {
                        rgb[0] = n
                        break
                    }
                    rgb[i] = n * 16 + n
                } else {
                    let m = hex(char: cstr[i * 2 + 1])
                    guard m >= 0 else {
                        rgb[0] = m
                        break
                    }
                    let n = hex(char: cstr[i * 2 + 2])
                    guard n >= 0 else {
                        rgb[0] = n
                        break
                    }
                    rgb[i] = m * 16 + n
                }
            }
        }
        if rgb[0] >= 0 {
            self = Rgb(UInt8(rgb[0]), UInt8(rgb[1]), UInt8(rgb[2]))
        } else {
            self = Rgb.black
        }
    }
}

extension Rgb: Color {

    public typealias InexactNumber = Float

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

    public typealias InterpolatableNumber = Float

    public func interpolate(_ y: Rgb, t: Float) -> Rgb {
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

extension Rgb {

    /// Derives a `Rgb` color from the receiver with given _red_ value.
    public func red(_ r: Float) -> Rgb {
        var clr = self
        clr.red = r
        return clr
    }

    /// Derives a `Rgb` color from the receiver with given _green_ value.
    public func green(_ g: Float) -> Rgb {
        var clr = self
        clr.green = g
        return clr
    }

    /// Derives a `Rgb` color from the receiver with given _blue_ value.
    public func blue(_ b: Float) -> Rgb {
        var clr = self
        clr.blue = b
        return clr
    }

    /// Derives a `Rgb` color from the receiver with given _alpha_ value.
    public func alpha(_ a: Float) -> Rgb {
        var clr = self
        clr.alpha = a
        return clr
    }
}
