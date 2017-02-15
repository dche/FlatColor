//
// FlatColor - Hsb.swift
//
// HSB color model.
//
// Copyright (c) 2016 The FlatColor authors.
// Licensed under MIT License.

// For `floor(:Float)`.
#if os(Linux)
    import Glibc
#else
    import simd
#endif

import FlatUtil
import GLMath

/// Color value in HSB color model.
public struct Hsb: Color {

    fileprivate var _hsba = vec4.zero

    public var hue: Float {
        get { return _hsba.x }
        set { _hsba.x = clamp(newValue, 0, Float.tau) }
    }

    public var saturation: Float {
        get { return _hsba.y }
        set { _hsba.y = clamp(newValue, 0, 1) }
    }

    public var brightness: Float {
        get { return _hsba.z }
        set { _hsba.z = clamp(newValue, 0, 1) }
    }

    public var alpha: Float {
        get { return _hsba.w }
        set { _hsba.w = clamp(newValue, 0, 1) }
    }

    fileprivate init (_ hsba: vec4) {
        self._hsba = clamp(hsba, vec4(0), vec4(Float.tau, 1, 1, 1))
    }

    /// Constructs a HSB color.
    ///
    /// - note: Parameter `h` is expected in the range of `[0, 2π]`.
    public init (hue: Float, saturation: Float, brightness: Float, alpha: Float = 1) {
        self.init(vec4(hue, saturation, brightness, alpha))
    }
}

// MARK: Color

extension Hsb {

    public init (rgb: Rgb) {
        let h = rgb.hue
        let s = rgb.saturation
        let b = rgb.brightness
        _hsba = vec4(h, s, b, rgb.alpha)
    }

    public var rgbColor: Rgb {
        let h = self.hue
        let s = self.saturation
        let v = self.brightness

        if s.isZero { return Rgb(red: v, green: v, blue: v) }
        else {
            let hv = degrees(h) / 60
            let hi = mod(floor(hv), 6)
            let f = hv - hi
            let p = v * (1 - s)
            let q = v * (1 - f * s)
            let t = v * (1 - (1 - f) * s)

            switch hi {
            case 0: return Rgb(red: v, green: t, blue: p)
            case 1: return Rgb(red: q, green: v, blue: p)
            case 2: return Rgb(red: p, green: v, blue: t)
            case 3: return Rgb(red: p, green: q, blue: v)
            case 4: return Rgb(red: t, green: p, blue: v)
            case 5: return Rgb(red: v, green: p, blue: q)
            default: fatalError("Unreachable!")
            }
        }
    }

    public var vector: vec4 { return self._hsba }
}

extension Hsb: Random {

    public init(withRng rng: inout Rng) {
        let h = rng.nextFloat() * Float.tau
        let s = rng.nextFloat() // TODO: Should be nextFloatClosed().
        let b = rng.nextFloat()
        self.init(vec4(h, s, b, 1))
    }
}

extension Hsb: CustomStringConvertible {

    public var description: String {
        return "Hsb(hue: \(self.hue), saturation: \(self.saturation), brightness: \(self.brightness), alpha: \(self.alpha))"
    }
}

extension Rgb {

    /// The hue of of a RGB color.
    public var hue: Float {
        let r = self.red
        let g = self.green
        let b = self.blue

        let mx = max(r, max(g, b))
        let mn = min(r, min(g, b))

        if mx ~== mn { return 0 }
        else {
            let c = (mx - mn).recip

            let deg: Float
            switch mx {
            case _ where mx == r: deg = mod(((g - b) * c), 6)
            case _ where mx == g: deg = ((b - r) * c) + 2
            default: deg = ((r - g) * c) + 4
            }
            return radians(mod((deg * 60 + 360), 360))
        }
    }

    /// The saturation of a RGB color.
    public var saturation: Float {
        let r = self.red
        let g = self.green
        let b = self.blue

        let mx = max(r, max(g, b))
        let mn = min(r, min(g, b))

        if mx ~== mn {
            // gray.
            return 0
        } else {
            return 1 - mn / mx
        }
    }

    /// The brightness of a RGB color.
    public var brightness: Float {
        return self.vector.rgb.max
    }
}
