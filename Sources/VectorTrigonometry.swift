// VectorTrigonometry.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

import Accelerate

// MARK: - Trigonometric operations on vector

/// Return the sine of `a`, where `a` is given in radians and the return value is
/// in the range -1 to 1.
///
/// - Parameters
///     - a: vector
/// - Returns: sine of a vector values
public func sin(_ a: Vector) -> Vector {
    return vectorFunction(vvsin, a)
}

/// Return the cosine of `a`, where `a` is given in radians and the return value is
/// in the range -1 to 1.
///
/// - Parameters
///     - a: vector
/// - Returns: cosine of a vector values
public func cos(_ a: Vector) -> Vector {
    return vectorFunction(vvcos, a)
}

/// Return the tangent of `a`, where `a` is given in radians.
///
/// Mathematically, the tangent function has singularities at odd multiples of
/// pi/2. If the argument x is too close to one of these singularities, tan
/// will return extremely large value.
///
/// - Parameters
///     - a: vector
/// - Returns: tangent of a vector values
public func tan(_ a: Vector) -> Vector {
    return vectorFunction(vvtan, a)
}

/// Return the arcsine of `a`, where return value is
/// in the range -pi/2 to pi/2.
///
/// - Parameters
///     - a: vector
/// - Returns: arcsine of a vector values
public func asin(_ a: Vector) -> Vector {
    return vectorFunction(vvasin, a)
}

/// Return the arccosine of `a`, where return value is
/// in the range 0 to pi.
///
/// - Parameters
///     - a: vector
/// - Returns: arccosine of a vector values
public func acos(_ a: Vector) -> Vector {
    return vectorFunction(vvacos, a)
}

/// Return the arctangent of `a`.
///
/// - Parameters
///     - a: vector
/// - Returns: arctangent of a vector values
public func atan(_ a: Vector) -> Vector {
    return vectorFunction(vvatan, a)
}
