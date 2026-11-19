// Vector.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

import Accelerate

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
/// - Returns: random values vector of specified size
public func rand(_ count: Int) -> Vector {
    var iDist = __CLPK_integer(1)
    var iSeed = (0..<4).map { _ in __CLPK_integer(Random.within(0.0...4095.0)) }
    var n = __CLPK_integer(count)
    var x = Vector(repeating: 0.0, count: count)
    dlarnv_(&iDist, &iSeed, &n, &x)
    return x
}

/// Create a vector of normally distributed  random values.
///
/// - Parameters:
///    - count: number of elements
/// - Returns: random values vector of specified size
public func randn(_ count: Int) -> Vector {
    var iDist = __CLPK_integer(3)
    var iSeed = (0..<4).map { _ in __CLPK_integer(Random.within(0.0...4095.0)) }
    var n = __CLPK_integer(count)
    var x = Vector(repeating: 0.0, count: count)
    dlarnv_(&iDist, &iSeed, &n, &x)
    return x
}

// MARK: - Vector comparison

/// Check if two vectors are equal using Double value approximate comparison
public func == (lhs: Vector, rhs: Vector) -> Bool {
    return lhs ==~ rhs
}

/// Check if two vectors are not equal using Double value approximate comparison
public func != (lhs: Vector, rhs: Vector) -> Bool {
    return lhs !=~ rhs
}

/// Check if one vector is greater than another using Double value approximate comparison
public func > (lhs: Vector, rhs: Vector) -> Bool {
    return lhs >~ rhs
}

/// Check if one vector is less than another using Double value approximate comparison
public func < (lhs: Vector, rhs: Vector) -> Bool {
    return lhs <~ rhs
}

/// Check if one vector is greater than or equal to another using Double value approximate comparison
public func >= (lhs: Vector, rhs: Vector) -> Bool {
    return lhs >=~ rhs
}

/// Check if one vector is less than or equal to another using Double value approximate comparison
public func <= (lhs: Vector, rhs: Vector) -> Bool {
    return lhs <=~ rhs
}
