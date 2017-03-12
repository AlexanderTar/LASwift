// MatrixExponent.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

// MARK: - Power and exponential functions

/// Exponentiation function, returning matrix raised to power.
///
/// Alternatively, `power(A, p)` can be executed with `A .^ p`.
///
/// Mathematically, `power` would return a complex number when base is negative and
/// power is not an integral value. `power` can’t do that,
/// so instead it signals domain error (returns `±NaN`).
///
/// - Parameters
///     - A: matrix
///     - p: power to raise matrix to
/// - Returns: elementwise matrix power of a raised to p
public func power(_ A: Matrix, _ b: Double) -> Matrix {
    return matrixScalarOperation(power, A, b)
}

/// Exponentiation function, returning matrix raised to power.
///
/// Alternatively, `A .^ p` can be executed with `power(A, p)`.
///
/// Mathematically, `power` would return a complex number when base is negative and
/// power is not an integral value. `power` can’t do that,
/// so instead it signals domain error (returns `±NaN`).
///
/// - Parameters
///     - A: matrix
///     - p: power to raise matrix to
/// - Returns: elementwise matrix power of a raised to p
public func .^ (_ A: Matrix, _ p: Double) -> Matrix {
    return power(A, p)
}

/// Exponentiation function, returning matrix raised to power of 2.
///
/// - Parameters
///     - A: matrix
/// - Returns: elementwise vector power of a matrix to power of 2
public func square(_ A: Matrix) -> Matrix {
    return matrixFunction(square, A)
}

/// Exponentiation function, returning square root of matrix.
///
/// Mathematically, `sqrt` would return a complex number when base is negative.
/// `sqrt` can’t do that, so instead it signals domain error (returns `±NaN`).
///
/// - Parameters
///     - A: matrix
/// - Returns: elementwise square root of matrix A
public func sqrt(_ A: Matrix) -> Matrix {
    return matrixFunction(sqrt, A)
}

///  Compute `e` (the base of natural logarithms) raised to the power `A`.
///
///  If the magnitude of the result is too large to be representable, exp
///  signals overflow (returns `Inf`).
///
/// - Parameters
///     - A: matrix
/// - Returns: elementwise `e` raised to the power of matrix A
public func exp(_ A: Matrix) -> Matrix {
    return matrixFunction(exp, A)
}

/// Compute the natural logarithm of `A` where `exp(log(A))` equals `A`, exactly in
/// mathematics and approximately in C.
///
/// If x is negative, log signals a domain error (returns `NaN`). If x is zero, it returns
/// negative infinity (`-Inf`); if x is too close to zero, it may signal overflow.
///
/// - Parameters
///     - A: matrix
/// - Returns: elementwise natural logarithm of matrix A
public func log(_ A: Matrix) -> Matrix {
    return matrixFunction(log, A)
}

/// Return the base-2 logarithm of `A`, where `log2(A) = log(A)/log(2)`.
///
/// - Parameters
///     - A: matrix
/// - Returns: elementwise base-2 logarithm of matrix A
public func log2(_ A: Matrix) -> Matrix {
    return matrixFunction(log2, A)
}

/// Return the base-10 logarithm of `A`, where `log10(A) = log(A)/log(10)`.
///
/// - Parameters
///     - A: matrix
/// - Returns: elementwise base-10 logarithm of matrix A
public func log10(_ A: Matrix) -> Matrix {
    return matrixFunction(log10, A)
}
