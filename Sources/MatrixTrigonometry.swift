// MatrixTrigonometry.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

// MARK: - Trigonometric functions on matrix

/// Return the sine of `A`, where `A` is given in radians and the return value is
/// in the range -1 to 1.
///
/// - Parameters
///     - A: matrix
/// - Returns: sine of a matrix values
public func sin(_ A: Matrix) -> Matrix {
    return matrixFunction(sin, A)
}

/// Return the cosine of `A`, where `A` is given in radians and the return value is
/// in the range -1 to 1.
///
/// - Parameters
///     - A: matrix
/// - Returns: cosine of a matrix values
public func cos(_ A: Matrix) -> Matrix {
    return matrixFunction(cos, A)
}

/// Return the tangent of `A`, where `A` is given in radians.
///
/// Mathematically, the tangent function has singularities at odd multiples of
/// pi/2. If the argument x is too close to one of these singularities, tan
/// will return extremely large value.
///
/// - Parameters
///     - A: matrix
/// - Returns: tangent of a matrix values
public func tan(_ A: Matrix) -> Matrix {
    return matrixFunction(tan, A)
}

/// Return the arcsine of `A`, where return value is
/// in the range -pi/2 to pi/2.
///
/// - Parameters
///     - A: matrix
/// - Returns: arcsine of a matrix values
public func asin(_ A: Matrix) -> Matrix {
    return matrixFunction(asin, A)
}

/// Return the arccosine of `A`, where return value is
/// in the range 0 to pi.
///
/// - Parameters
///     - A: matrix
/// - Returns: arccosine of a matrix values
public func acos(_ A: Matrix) -> Matrix {
    return matrixFunction(acos, A)
}

/// Return the arctangent of `a`.
///
/// - Parameters
///     - A: matrix
/// - Returns: arctangent of a matrix values
public func atan(_ A: Matrix) -> Matrix {
    return matrixFunction(atan, A)
}
