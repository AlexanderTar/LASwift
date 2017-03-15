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
/// - Returns: largest element of vector a
public func max(_ a: Vector) -> Double {
    return aggVectorFunction(vDSP_maxvD, a)
}

/// Return the index of largest element of vector.
///
/// - Parameters
///     - a: vector
/// - Returns: index of largest element of vector a
public func maxi(_ a: Vector) -> Int {
    return aggVectorIFunction(vDSP_maxviD, a)
}

/// Return the smallest element of vector.
///
/// - Parameters
///     - a: vector
/// - Returns: smallest element of vector a
public func min(_ a: Vector) -> Double {
    return aggVectorFunction(vDSP_minvD, a)
}

/// Return the index of smallest element of vector.
///
/// - Parameters
///     - a: vector
/// - Returns: index of smallest element of vector a
public func mini(_ a: Vector) -> Int {
    return aggVectorIFunction(vDSP_minviD, a)
}

/// Return mean (statistically average) value of vector.
///
/// - Parameters
///     - a: vector
/// - Returns: mean value of vector a
public func mean(_ a: Vector) -> Double {
    return aggVectorFunction(vDSP_meanvD, a)
}

/// Return standard deviation value of vector.
///
/// - Parameters
///     - a: vector
/// - Returns: standard deviation value of vector a
public func std(_ a: Vector) -> Double {
    var m: Double = 0.0
    var s: Double = 0.0
    var c = Vector(repeating: 0.0, count: a.count)
    vDSP_normalizeD(a, 1, &c, 1, &m, &s, vDSP_Length(a.count))
    return s
}

/// Return normalized vector (substract mean value and divide by standard deviation).
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
