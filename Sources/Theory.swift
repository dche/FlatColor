//
// FlatColor - Theory.swift
//
// Copyright (c) 2016 The FlatColor authors.
// Licensed under MIT License.

import GLMath

public extension Hsb {

    /// The complementary color of a HSB color.
    public var complement: Hsb {
        var c = self
        c.hue = mod(self.hue + Float.π, Float.tau)
        return c
    }

    /// Returns a pair of colors that are splited from the complementary color
    /// of a HSB color,
    ///
    /// These 2 colors have same distances to the complementary color on the
    /// color wheel. In our implementation, this distance is fixed to `30`
    /// degrees.
    public var splitComplement: (Hsb, Hsb) {
        let pi2 = Float.tau
        var c1 = self
        var c2 = self
        c1.hue = mod(self.hue + radians(150), pi2);
        c2.hue = mod(self.hue + radians(210), pi2);
        return (c1, c2)
    }

    /// Returns 2 pairs of complementary colors. The first colors of both pairs
    /// are the result of a HSB color's `split_complement`.
    public var doubleComplement: ((Hsb, Hsb), (Hsb, Hsb)) {
        let (c1, c2) = self.splitComplement
        return ((c1, c1.complement), (c2, c2.complement))
    }

    /// Returns other 2 colors of triad colors that includes the receiver.
    public var triad: (Hsb, Hsb) {
        let a120: Float = radians(120)
        var c1 = self
        var c2 = self
        c1.hue = mod(self.hue + a120, Float.tau);
        c2.hue = mod(self.hue + a120 + a120, Float.tau);
        return (c1, c2)
    }

    /// Returns `n` colors that are analogous to the receiver.
    ///
    /// - note:
    /// * `[]` is returned if `n` is `0` or negative,
    /// * `span` can be larger than `2π`,
    /// * `span` can be negative.
    public func analog(by n: Int, span: Float) -> [Hsb] {
        guard n > 0 else { return [] }
        guard !span.isZero else { return [Hsb](repeating: self, count: n) }

        let d = span / Float(n)
        let h = self.hue
        var cs = [self]
        for i in 1 ..< n {
            var clr = self
            clr.hue = h + d * Float(i)
            cs.append(clr)
        }
        return cs
    }

    /// Returns `n` colors distributed on the color wheel evenly.
    ///
    /// The returned colors have same saturation and brightness as `self`.
    /// `self` is the first color in the array.
    ///
    /// If `n` is `0`, an empty array is returned.
    public func colorWheel(_ n: Int) -> [Hsb] {
        return self.analog(by: n, span: Float.tau)
    }

    /// Produces a color by adding white to the receiver.
    ///
    /// For `Hsb` color model, adding white means increasing the lightness.
    ///
    /// Parameter `amt` specifies absolute lightness to be added.
    public func tinted(_ amount: Float) -> Hsb {
        var c = self
        c.brightness = self.brightness + amount
        return c
    }

    /// Produces a list of `n` colors whose brightness increase monotonically
    /// and evenly.
    ///
    /// If `n` is `0`, returns an empty array. Other wise, the receiver is
    /// the first element of the vector and a color with full brightness is
    /// the last.
    public func tinted(by n: Int) -> [Hsb] {
        switch n {
        case _ where n < 1:
            return []
        case 1:
            return [self]
        default:
            let b = self.brightness
            let d = (1 - b) / Float(n)
            var c = self
            var cs = [c]
            for i in 1 ..< n - 1 {
                c = self
                c.brightness = b + d * Float(i)
                cs.append(c)
            }
            c = self
            c.brightness = 1
            cs.append(c)
            return cs
        }
    }

    /// Produces a color by adding black to the receiver.
    public func shaded(_ amount: Float) -> Hsb {
        var c = self
        c.brightness = self.brightness - amount
        return c
    }

    /// Produces`n` colors whose brightness decrease monotonically and evenly.
    public func shaded(by n: Int) -> [Hsb] {
        switch n {
        case _ where n < 1:
            return []
        case 1:
            return [self]
        default:
            let b = self.brightness
            let d = b / Float(n)
            var c = self
            var cs = [c]
            for i in 1 ..< n - 1 {
                c = self
                c.brightness = b - d * Float(i)
                cs.append(c)
            }
            c = self
            c.brightness = 0
            cs.append(c)
            return cs
        }
    }

    /// Produces a color by adding gray to the receiver, i.e., decreases its
    /// saturation.
    public func tone(_ amount: Float) -> Hsb {
        var c = self
        c.saturation = self.saturation - amount
        return c
    }

    /// Produces `n` colors whose saturation decrease monotonically and
    /// evenly.
    public func tone(by n: Int) -> [Hsb] {
        switch n {
        case _ where n < 1:
            return []
        case 1:
            return [self]
        default:
            let s = self.saturation
            let d = s / Float(n)
            var c = self
            var cs = [c]
            for i in 1 ..< n - 1 {
                c = self
                c.saturation = s - d * Float(i)
                cs.append(c)
            }
            c = self
            c.saturation = 0
            cs.append(c)
            return cs
        }
    }
}
