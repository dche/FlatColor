//
// FlatColor - Color.swift
//
// Copyright (c) 2017 The FlatColor authors.
// Licensed under MIT License.

// For matrix-vector multiplication.
#if !os(Linux)
    import simd
#endif

import FlatUtil
import GLMath

/// The YCbCr color model.
public struct YCbCr {

    fileprivate var _ybra: vec4

    public var y: Float {
        get { return _ybra.x }
        set { _ybra.x = clamp(newValue, 0, 1) }
    }

    public var cb: Float {
        get { return _ybra.y }
        set { _ybra.y = clamp(newValue, -0.5, 0.5) }
    }

    public var cr: Float {
        get { return _ybra.z }
        set { _ybra.z = clamp(newValue, -0.5, 0.5) }
    }

    public var alpha: Float {
        get { return _ybra.w }
        set { _ybra.w = clamp(newValue, 0, 1) }
    }

    init (_ ybra: vec4) {
        self._ybra = clamp(ybra, vec4(0, -0.5, -0.5, 0), vec4(1, 0.5, 0.5, 1))
    }

    public init (y: Float, cb: Float, cr: Float, alpha: Float = 1) {
        self.init(vec4(y, cb, cr, alpha))
    }
}

extension YCbCr: Color {

    public typealias InexactNumber = Float

    public init (rgb: Rgb) {
        // ITU.BT-709
        let clrMat = mat3(
            vec3(0.2126, -0.1146,  0.5),
            vec3(0.7152, -0.3854, -0.4542),
            vec3(0.0722,  0.5,    -0.0458)
        )
        let v = clrMat * rgb.vector.rgb
        self.init(vec4(v, rgb.alpha))
    }

    public var rgbColor: Rgb {
        // Not exactly the inverse of color matrix in `from_rgb`,
        // so the rounding errors of conversion back and forth are large.
        let clrMat = mat3(
            vec3(1,       1,      1),
            vec3(0,      -0.1873, 1.8556),
            vec3(1.5748, -0.4682, 0)
        )
        let v = clrMat * self.vector.rgb
        return Rgb(vec4(v, self.vector.a))
    }

    public static let zero = YCbCr(vec4.zero)

    public var vector: vec4 { return self._ybra }
}

extension YCbCr: Random {

    public init(withRng rng: inout Rng) {
        self = YCbCr(rgb: Rgb(withRng: &rng))
    }
}

extension YCbCr: CustomStringConvertible {

    public var description: String {
        return "YCbCr(y: \(self.y), cb: \(self.cb), cr: \(self.cr), alpha: \(self.alpha))"
    }
}
