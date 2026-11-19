// Vector.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

import Accelerate
import CLASwiftLAPACK

/// Typealiasing of array of Doubles to Vector
/// to make functions more mathematical.
public typealias Vector = [Double]

// MARK: - One-line creators for vectors

/// Create a vector of zeros.
///
/// - Parameters:
///    - count: number of elements
/// - Returns: zeros vector of specified size
public func zeros(_ count: Int) -> Vector {
    return Vector(repeating: 0.0, count: count)
}

/// Create a vector of ones.
///
/// - Parameters:
///    - count: number of elements
/// - Returns: ones vector of specified size
public func ones(_ count: Int) -> Vector {
    return Vector(repeating: 1.0, count: count)
}

/// Create a vector of uniformly distributed on [0, 1) interval random values.
///
/// - Parameters:
///    - count: number of elements
///    - seed: optional seed; the same seed always gives the same values. Without one,
///            every call gives different values.
/// - Returns: random values vector of specified size
public func rand(_ count: Int, seed: UInt64? = nil) -> Vector {
    var iDist = Int(1)
    var iSeed = Random.iSeed(seed)
    var n = Int(count)
    var x = Vector(repeating: 0.0, count: count)
    laswift_dlarnv(&iDist, &iSeed, &n, &x)
    return x
}

/// Create a vector of normally distributed  random values.
///
/// - Parameters:
///    - count: number of elements
///    - seed: optional seed; the same seed always gives the same values. Without one,
///            every call gives different values.
/// - Returns: random values vector of specified size
public func randn(_ count: Int, seed: UInt64? = nil) -> Vector {
    var iDist = Int(3)
    var iSeed = Random.iSeed(seed)
    var n = Int(count)
    var x = Vector(repeating: 0.0, count: count)
    laswift_dlarnv(&iDist, &iSeed, &n, &x)
    return x
}

// MARK: - Approximate comparison

/// Check if two values are equal within a tolerance.
///
/// The values are equal when `|a - b| <= max(absoluteTolerance, relativeTolerance * max(|a|, |b|))`.
/// Equal infinities are equal, an infinity is never close to a finite value,
/// and NaN is never equal to anything.
///
/// - Parameters:
///    - a: first value
///    - b: second value
///    - absoluteTolerance: largest accepted absolute difference (1e-14 by default)
///    - relativeTolerance: largest accepted difference relative to the larger magnitude (0 by default)
/// - Returns: `true` if the values are equal within the tolerance
public func isApproximatelyEqual(_ a: Double, _ b: Double,
                                 absoluteTolerance: Double = 1e-14,
                                 relativeTolerance: Double = 0) -> Bool {
    precondition(absoluteTolerance >= 0 && relativeTolerance >= 0, "Tolerances must be non-negative")
    if a == b {
        return true
    }
    guard a.isFinite && b.isFinite else {
        return false
    }
    return abs(a - b) <= max(absoluteTolerance, relativeTolerance * max(abs(a), abs(b)))
}

/// Check if two vectors have the same length and are equal elementwise within a tolerance.
///
/// See `isApproximatelyEqual(_:_:absoluteTolerance:relativeTolerance:)` for Double values.
public func isApproximatelyEqual(_ a: Vector, _ b: Vector,
                                 absoluteTolerance: Double = 1e-14,
                                 relativeTolerance: Double = 0) -> Bool {
    return a.count == b.count && zip(a, b).allSatisfy {
        isApproximatelyEqual($0, $1, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance)
    }
}
