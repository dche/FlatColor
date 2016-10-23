//
// FlatColor - Color.swift
//
// The Color protocol.
//
// Copyright (c) 2016 The FlatColor authors.
// Licensed under MIT License.

import simd
import FlatUtil
import GLMath

/// Generic color type.
public protocol Color: Equatable, Random, ApproxEquatable {

    /// Constructs a color from a RGB color.
    init (rgb: Rgb)

    /// The corresponding RGB color.
    var rgbColor: Rgb { get }

    /// The `alpha` value.
    var alpha: Float { get }

    /// The vector representation of `self`.
    var vector: vec4 { get }
}

extension Color {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.vector == rhs.vector
    }

    public typealias NumberType = Float

    public func isClose(to other: Self, tolerance: Float) -> Bool {
        return self.vector.isClose(to: other.vector, tolerance: tolerance)
    }

    /// Returns `true` if `self`'s `alpha` is less than `1`.
    public var isTransparent: Bool { return self.alpha < 1 }

    /// Returns `true` if `self` is _NOT_ transparent.
    public var isOpaque: Bool { return !isTransparent }
}
