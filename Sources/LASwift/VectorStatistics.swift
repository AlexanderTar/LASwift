// VectorStatistics.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

import Accelerate

// MARK: - Statistical operations on vector

/// Return the largest element of vector.
///
/// - Parameters
///     - a: vector
///
/// A precondition error is thrown if the vector is empty.
///
/// `NaN` elements are not handled consistently: depending on where the `NaN` sits,
/// `max` returns either `NaN` or the largest non-`NaN` element. Use `maxi` and `mini`,
/// which skip `NaN` elements, or remove `NaN` before calling.
///
/// - Returns: largest element of vector a
public func max(_ a: Vector) -> Double {
    precondition(!a.isEmpty, "max requires a non-empty vector")
    return aggVectorFunction(vDSP_maxvD, a)
}

/// Return the index of largest element of vector.
///
/// - Parameters
///     - a: vector
///
/// A precondition error is thrown if the vector is empty.
///
/// `NaN` elements are skipped (unlike `max`, which may return `NaN`),
/// so the index is never that of a `NaN` unless every element is `NaN` (then it is 0).
///
/// - Returns: index of largest element of vector a
public func maxi(_ a: Vector) -> Int {
    precondition(!a.isEmpty, "maxi requires a non-empty vector")
    return aggVectorIFunction(vDSP_maxviD, a)
}

/// Return the smallest element of vector.
///
/// - Parameters
///     - a: vector
///
/// A precondition error is thrown if the vector is empty. See `max` for `NaN` behaviour.
///
/// - Returns: smallest element of vector a
public func min(_ a: Vector) -> Double {
    precondition(!a.isEmpty, "min requires a non-empty vector")
    return aggVectorFunction(vDSP_minvD, a)
}

/// Return the index of smallest element of vector.
///
/// - Parameters
///     - a: vector
///
/// A precondition error is thrown if the vector is empty.
///
/// `NaN` elements are skipped (unlike `min`, which may return `NaN`),
/// so the index is never that of a `NaN` unless every element is `NaN` (then it is 0).
///
/// - Returns: index of smallest element of vector a
public func mini(_ a: Vector) -> Int {
    precondition(!a.isEmpty, "mini requires a non-empty vector")
    return aggVectorIFunction(vDSP_minviD, a)
}

/// Return mean (statistically average) value of vector.
///
/// - Parameters
///     - a: vector
///
/// A precondition error is thrown if the vector is empty.
///
/// - Returns: mean value of vector a
public func mean(_ a: Vector) -> Double {
    precondition(!a.isEmpty, "mean requires a non-empty vector")
    return aggVectorFunction(vDSP_meanvD, a)
}

/// How `std` normalises the sum of squared deviations from the mean.
public enum Normalization: Sendable {
    /// Divide by N - 1 (sample standard deviation, Matlab's default, NumPy `ddof=1`).
    case sample
    /// Divide by N (population standard deviation, NumPy's default `ddof=0`).
    case population
}

/// Return standard deviation value of vector.
///
/// By default this is the sample standard deviation (divides by N - 1), like Matlab's `std`.
/// Pass `normalization: .population` to divide by N. A vector of one element has deviation 0.
///
/// A precondition error is thrown if the vector is empty.
///
/// - Parameters
///     - a: vector
///     - normalization: `.sample` (N - 1, the default) or `.population` (N)
/// - Returns: standard deviation value of vector a
public func std(_ a: Vector, normalization: Normalization = .sample) -> Double {
    precondition(!a.isEmpty, "std requires a non-empty vector")
    var m: Double = 0.0
    var s: Double = 0.0
    var c = Vector(repeating: 0.0, count: a.count)
    // vDSP reports the population deviation (divides by N).
    vDSP_normalizeD(a, 1, &c, 1, &m, &s, vDSP_Length(a.count))
    if normalization == .sample && a.count > 1 {
        let n = Double(a.count)
        s *= (n / (n - 1)).squareRoot()
    }
    return s
}

/// Return normalized vector (substract mean value and divide by standard deviation).
///
/// The deviation is the population deviation (divides by N), so the result has population
/// standard deviation 1.
///
/// - Parameters
///     - a: vector
/// - Returns: normalized vector a
public func normalize(_ a: Vector) -> Vector {
    var m: Double = 0.0
    var s: Double = 0.0
    var c = Vector(repeating: 0.0, count: a.count)
    vDSP_normalizeD(a, 1, &c, 1, &m, &s, vDSP_Length(a.count))
    return c
}

/// Return sum of vector's elements.
///
/// - Parameters
///     - a: vector
/// - Returns: sum of elements of vector a
public func sum(_ a: Vector) -> Double {
    return aggVectorFunction(vDSP_sveD, a)
}

/// Return sum of vector's squared elements.
///
/// - Parameters
///     - a: vector
/// - Returns: sum of squared elements of vector a
public func sumsq(_ a: Vector) -> Double {
    return aggVectorFunction(vDSP_svesqD, a)
}
