// MatrixArithmetic.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

import Darwin

// MARK: - Matrix-Matrix arithmetics

/// Perform matrix addition.
///
/// Alternatively, `plus(A, B)` can be executed with `A + B`.
///
/// - Parameters
///     - A: left matrix
///     - B: right matrix
/// - Returns: elementwise matrix sum of A and B
public func plus(_ A: Matrix, _ B: Matrix) -> Matrix {
    return matrixMatrixOperation(plus, A, B)
}

/// Perform matrix addition.
///
/// Alternatively, `A + B` can be executed with `plus(A, B)`.
///
/// - Parameters
///     - A: left matrix
///     - B: right matrix
/// - Returns: elementwise matrix sum of A and B
public func + (_ A: Matrix, _ B: Matrix) -> Matrix {
    return plus(A, B)
}

/// Perform matrix substraction.
///
/// Alternatively, `minus(A, B)` can be executed with `A - B`.
///
/// - Parameters
///     - A: left matrix
///     - B: right matrix
/// - Returns: elementwise matrix difference of A and B
public func minus(_ A: Matrix, _ B: Matrix) -> Matrix {
    return matrixMatrixOperation(minus, A, B)
}

/// Perform matrix substraction.
///
/// Alternatively, `A - B` can be executed with `minus(A, B)`.
///
/// - Parameters
///     - A: left matrix
///     - B: right matrix
/// - Returns: elementwise matrix difference of A and B
public func - (_ A: Matrix, _ B: Matrix) -> Matrix {
    return minus(A, B)
}

/// Perform matrix multiplication.
///
/// Alternatively, `times(A, B)` can be executed with `A .* B`.
///
/// - Parameters
///     - A: left matrix
///     - B: right matrix
/// - Returns: elementwise matrix product of A and B
public func times(_ A: Matrix, _ B: Matrix) -> Matrix {
    return matrixMatrixOperation(times, A, B)
}

/// Perform matrix multiplication.
///
/// Alternatively, `A .* B` can be executed with `times(A, B)`.
///
/// - Parameters
///     - A: left matrix
///     - B: right matrix
/// - Returns: elementwise matrix product of A and B
public func .* (_ A: Matrix, _ B: Matrix) -> Matrix {
    return times(A, B)
}

/// Perform matrix right division.
///
/// Alternatively, `rdivide(A, B)` can be executed with `A ./ B`.
///
/// - Parameters
///     - A: left matrix
///     - B: right matrix
/// - Returns: result of elementwise division of A by B
public func rdivide(_ A: Matrix, _ B: Matrix) -> Matrix {
    return matrixMatrixOperation(rdivide, A, B)
}

/// Perform matrix right division.
///
/// Alternatively, `A ./ B` can be executed with `rdivide(A, B)`.
///
/// - Parameters
///     - A: left matrix
///     - B: right matrix
/// - Returns: result of elementwise division of A by B
public func ./ (_ A: Matrix, _ B: Matrix) -> Matrix {
    return rdivide(A, B)
}

/// Perform matrix left division.
///
/// Alternatively, `ldivide(A, B)` can be executed with `A ./. B`.
///
/// - Parameters
///     - A: left matrix
///     - B: right matrix
/// - Returns: result of elementwise division of B by A
public func ldivide(_ A: Matrix, _ B: Matrix) -> Matrix {
    return matrixMatrixOperation(ldivide, A, B)
}

/// Perform matrix left division.
///
/// Alternatively, `A ./. B` can be executed with `ldivide(A, B)`.
///
/// - Parameters
///     - A: left matrix
///     - B: right matrix
/// - Returns: result of elementwise division of B by A
public func ./. (_ A: Matrix, _ B: Matrix) -> Matrix {
    return ldivide(A, B)
}

// MARK: - Matrix-Scalar arithmetics

/// Perform matrix and scalar addition.
///
/// Scalar value expands to matrix dimensions
/// and elementwise matrix addition is performed.
///
/// Alternatively, `plus(A, b)` can be executed with `A + b`.
///
/// - Parameters
///     - A: matrix
///     - b: scalar
/// - Returns: elementwise sum of matrix A and scalar b
public func plus(_ A: Matrix, _ b: Double) -> Matrix {
    return matrixScalarOperation(plus, A, b)
}

/// Perform matrix and scalar addition.
///
/// Scalar value expands to matrix dimensions
/// and elementwise matrix addition is performed.
///
/// Alternatively, `A + b` can be executed with `plus(A, b)`.
///
/// - Parameters
///     - A: matrix
///     - b: scalar
/// - Returns: elementwise sum of matrix A and scalar b
public func + (_ A: Matrix, _ b: Double) -> Matrix {
    return plus(A, b)
}

/// Perform scalar and matrix addition.
///
/// Scalar value expands to matrix dimensions
/// and elementwise matrix addition is performed.
///
/// Alternatively, `plus(a, B)` can be executed with `a + B`.
///
/// - Parameters
///     - a: scalar
///     - B: matrix
/// - Returns: elementwise sum of scalar a and matrix B
public func plus(_ a: Double, _ B: Matrix) -> Matrix {
    return invMatrixScalarOperation(plus, a, B)
}

/// Perform scalar and matrix addition.
///
/// Scalar value expands to matrix dimensions
/// and elementwise matrix addition is performed.
///
/// Alternatively, `a + B` can be executed with `plus(a, B)`.
///
/// - Parameters
///     - a: scalar
///     - B: matrix
/// - Returns: elementwise sum of scalar a and matrix B
public func + (_ a: Double, _ B: Matrix) -> Matrix {
    return plus(a, B)
}

/// Perform matrix and scalar substraction.
///
/// Scalar value expands to matrix dimensions
/// and elementwise matrix substraction is performed.
///
/// Alternatively, `minus(A, b)` can be executed with `A - b`.
///
/// - Parameters
///     - A: matrix
///     - b: scalar
/// - Returns: elementwise difference of matrix A and scalar b
public func minus(_ A: Matrix, _ b: Double) -> Matrix {
    return matrixScalarOperation(minus, A, b)
}

/// Perform matrix and scalar substraction.
///
/// Scalar value expands to matrix dimensions
/// and elementwise matrix substraction is performed.
///
/// Alternatively, `A - b` can be executed with `minus(A, b)`.
///
/// - Parameters
///     - A: matrix
///     - b: scalar
/// - Returns: elementwise difference of matrix A and scalar b
public func - (_ A: Matrix, _ b: Double) -> Matrix {
    return minus(A, b)
}

/// Perform scalar and matrix substraction.
///
/// Scalar value expands to matrix dimensions
/// and elementwise matrix addition is performed.
///
/// Alternatively, `minus(a, B)` can be executed with `a - B`.
///
/// - Parameters
///     - a: scalar
///     - B: matrix
/// - Returns: elementwise difference of scalar a and matrix B
public func minus(_ a: Double, _ B: Matrix) -> Matrix {
    return invMatrixScalarOperation(minus, a, B)
}

/// Perform scalar and matrix substraction.
///
/// Scalar value expands to matrix dimensions
/// and elementwise matrix addition is performed.
///
/// Alternatively, `a - B` can be executed with `minus(a, B)`.
///
/// - Parameters
///     - a: scalar
///     - B: matrix
/// - Returns: elementwise difference of scalar a and matrix B
public func - (_ a: Double, _ B: Matrix) -> Matrix {
    return minus(a, B)
}

/// Perform matrix and scalar multiplication.
///
/// Scalar value expands to matrix dimensions
/// and elementwise matrix multiplication is performed.
///
/// Alternatively, `times(A, b)` can be executed with `A .* b`.
///
/// - Parameters
///     - A: matrix
///     - b: scalar
/// - Returns: elementwise product of matrix A and scalar b
public func times(_ A: Matrix, _ b: Double) -> Matrix {
    return matrixScalarOperation(times, A, b)
}

/// Perform matrix and scalar multiplication.
///
/// Scalar value expands to matrix dimensions
/// and elementwise matrix multiplication is performed.
///
/// Alternatively, `A .* b` can be executed with `times(A, b)`.
///
/// - Parameters
///     - A: matrix
///     - b: scalar
/// - Returns: elementwise product of matrix A and scalar b
public func .* (_ A: Matrix, _ b: Double) -> Matrix {
    return times(A, b)
}

/// Perform scalar and matrix multiplication.
///
/// Scalar value expands to matrix dimensions
/// and elementwise matrix multiplication is performed.
///
/// Alternatively, `times(a, B)` can be executed with `a .* B`.
///
/// - Parameters
///     - a: scalar
///     - B: matrix
/// - Returns: elementwise product of scalar a and matrix B
public func times(_ a: Double, _ B: Matrix) -> Matrix {
    return invMatrixScalarOperation(times, a, B)
}

/// Perform scalar and matrix multiplication.
///
/// Scalar value expands to matrix dimensions
/// and elementwise matrix multiplication is performed.
///
/// Alternatively, `a .* B` can be executed with `times(a, B)`.
///
/// - Parameters
///     - a: scalar
///     - B: matrix
/// - Returns: elementwise product of scalar a and matrix B
public func .* (_ a: Double, _ B: Matrix) -> Matrix {
    return times(a, B)
}

/// Perform matrix and scalar right division.
///
/// Scalar value expands to matrix dimensions
/// and elementwise matrix right division is performed.
///
/// Alternatively, `rdivide(A, b)` can be executed with `A ./ b`.
///
/// - Parameters
///     - A: matrix
///     - b: scalar
/// - Returns: result of elementwise division of matrix A by scalar b
public func rdivide(_ A: Matrix, _ b: Double) -> Matrix {
    return matrixScalarOperation(rdivide, A, b)
}

/// Perform matrix and scalar right division.
///
/// Scalar value expands to matrix dimensions
/// and elementwise matrix right division is performed.
///
/// Alternatively, `A ./ b` can be executed with `rdivide(A, b)`.
///
/// - Parameters
///     - A: matrix
///     - b: scalar
/// - Returns: result of elementwise division of matrix A by scalar b
public func ./ (_ A: Matrix, _ b: Double) -> Matrix {
    return rdivide(A, b)
}

/// Perform scalar and matrix right division.
///
/// Scalar value expands to matrix dimensions
/// and elementwise matrix right division is performed.
///
/// Alternatively, `rdivide(a, B)` can be executed with `a ./ B`.
///
/// - Parameters
///     - a: scalar
///     - B: matrix
/// - Returns: result of elementwise division of scalar a by matrix B
public func rdivide(_ a: Double, _ B: Matrix) -> Matrix {
    return invMatrixScalarOperation(rdivide, a, B)
}

/// Perform scalar and matrix right division.
///
/// Scalar value expands to matrix dimension
/// and elementwise matrix right division is performed.
///
/// Alternatively, `a ./ B` can be executed with `rdivide(a, B)`.
///
/// - Parameters
///     - a: scalar
///     - B: matrix
/// - Returns: result of elementwise division of scalar a by matrix B
public func ./ (_ a: Double, _ B: Matrix) -> Matrix {
    return rdivide(a, B)
}

/// Perform matrix and scalar left division.
///
/// Scalar value expands to matrix dimensions
/// and elementwise matrix left division is performed.
///
/// Alternatively, `ldivide(A, b)` can be executed with `A ./. b`.
///
/// - Parameters
///     - A: matrix
///     - b: scalar
/// - Returns: result of elementwise division of scalar b by matrix A
public func ldivide(_ A: Matrix, _ b: Double) -> Matrix {
    return matrixScalarOperation(ldivide, A, b)
}

/// Perform matrix and scalar left division.
///
/// Scalar value expands to matrix dimensions
/// and elementwise matrix left division is performed.
///
/// Alternatively, `A ./. b` can be executed with `ldivide(A, b)`.
///
/// - Parameters
///     - A: matrix
///     - b: scalar
/// - Returns: result of elementwise division of scalar b by matrix aA
public func ./. (_ A: Matrix, _ b: Double) -> Matrix {
    return ldivide(A, b)
}

/// Perform scalar and matrix left division.
///
/// Scalar value expands to matrix dimensions
/// and elementwise matrix left division is performed.
///
/// Alternatively, `ldivide(a, B)` can be executed with `a ./. B`.
///
/// - Parameters
///     - a: scalar
///     - B: matrix
/// - Returns: result of elementwise division of matrix B by scalar a
public func ldivide(_ a: Double, _ B: Matrix) -> Matrix {
    return invMatrixScalarOperation(ldivide, a, B)
}

/// Perform scalar and matrix left division.
///
/// Scalar value expands to matrix dimensions
/// and elementwise matrix left division is performed.
///
/// Alternatively, `a ./. B` can be executed with `ldivide(a, B)`.
///
/// - Parameters
///     - a: scalar
///     - B: matrix
/// - Returns: result of elementwise division of matrix B by scalar a
public func ./. (_ a: Double, _ B: Matrix) -> Matrix {
    return ldivide(a, B)
}

// MARK: - Matrix-Vector arithmetics

/// Perform matrix and vector addition.
///
/// Vector value expands to matrix dimensions (by rows)
/// and elementwise matrix addition is performed.
///
/// Alternatively, `plus(A, b)` can be executed with `A + b`.
///
/// - Parameters
///     - A: matrix
///     - b: vector
/// - Returns: elementwise sum of matrix A and vector b
public func plus(_ A: Matrix, _ b: Vector) -> Matrix {
    return matrixVectorOperation(plus, A, b)
}

/// Perform matrix and vector addition.
///
/// Vector value expands to matrix dimensions (by rows)
/// and elementwise matrix addition is performed.
///
/// Alternatively, `A + b` can be executed with `plus(A, b)`.
///
/// - Parameters
///     - A: matrix
///     - b: vector
/// - Returns: elementwise sum of matrix A and vector b
public func + (_ A: Matrix, _ b: Vector) -> Matrix {
    return plus(A, b)
}

/// Perform vector and matrix addition.
///
/// Vector value expands to matrix dimensions (by rows)
/// and elementwise matrix addition is performed.
///
/// Alternatively, `plus(a, B)` can be executed with `a + B`.
///
/// - Parameters
///     - a: vector
///     - B: matrix
/// - Returns: elementwise sum of vector a and matrix B
public func plus(_ a: Vector, _ B: Matrix) -> Matrix {
    return invMatrixVectorOperation(plus, a, B)
}

/// Perform vector and matrix addition.
///
/// Vector value expands to matrix dimensions (by rows)
/// and elementwise matrix addition is performed.
///
/// Alternatively, `a + B` can be executed with `plus(a, B)`.
///
/// - Parameters
///     - a: vector
///     - B: matrix
/// - Returns: elementwise sum of vector a and matrix B
public func + (_ a: Vector, _ B: Matrix) -> Matrix {
    return plus(a, B)
}

/// Perform matrix and vector substraction.
///
/// Vector value expands to matrix dimensions (by rows)
/// and elementwise matrix addition is performed.
///
/// Alternatively, `minus(A, b)` can be executed with `A - b`.
///
/// - Parameters
///     - A: matrix
///     - b: vector
/// - Returns: elementwise difference of matrix A and vector b
public func minus(_ A: Matrix, _ b: Vector) -> Matrix {
    return matrixVectorOperation(minus, A, b)
}

/// Perform matrix and vector substraction.
///
/// Vector value expands to matrix dimensions (by rows)
/// and elementwise matrix addition is performed.
///
/// Alternatively, `A - b` can be executed with `minus(A, b)`.
///
/// - Parameters
///     - A: matrix
///     - b: vector
/// - Returns: elementwise difference of matrix A and vector b
public func - (_ A: Matrix, _ b: Vector) -> Matrix {
    return minus(A, b)
}

/// Perform vector and matrix substraction.
///
/// Vector value expands to matrix dimensions (by rows)
/// and elementwise matrix addition is performed.
///
/// Alternatively, `minus(a, B)` can be executed with `a - B`.
///
/// - Parameters
///     - a: vector
///     - B: matrix
/// - Returns: elementwise difference of vector a and matrix B
public func minus(_ a: Vector, _ B: Matrix) -> Matrix {
    return invMatrixVectorOperation(minus, a, B)
}

/// Perform vector and matrix substraction.
///
/// Vector value expands to matrix dimensions (by rows)
/// and elementwise matrix addition is performed.
///
/// Alternatively, `a - B` can be executed with `minus(a, B)`.
///
/// - Parameters
///     - a: vector
///     - B: matrix
/// - Returns: elementwise difference of vector a and matrix B
public func - (_ a: Vector, _ B: Matrix) -> Matrix {
    return minus(a, B)
}

/// Perform matrix and vector multiplication.
///
/// Vector value expands to matrix dimensions (by rows)
/// and elementwise matrix addition is performed.
///
/// Alternatively, `times(A, b)` can be executed with `A .* b`.
///
/// - Parameters
///     - A: matrix
///     - b: vector
/// - Returns: elementwise product of matrix A and vector b
public func times(_ A: Matrix, _ b: Vector) -> Matrix {
    return matrixVectorOperation(times, A, b)
}

/// Perform matrix and vector multiplication.
///
/// Vector value expands to matrix dimensions (by rows)
/// and elementwise matrix addition is performed.
///
/// Alternatively, `A .* b` can be executed with `times(A, b)`.
///
/// - Parameters
///     - A: matrix
///     - b: vector
/// - Returns: elementwise product of matrix A and vector b
public func .* (_ A: Matrix, _ b: Vector) -> Matrix {
    return times(A, b)
}

/// Perform vector and matrix multiplication.
///
/// Vector value expands to matrix dimensions (by rows)
/// and elementwise matrix addition is performed.
///
/// Alternatively, `times(a, B)` can be executed with `a .* B`.
///
/// - Parameters
///     - a: vector
///     - B: matrix
/// - Returns: elementwise product of vector a and matrix B
public func times(_ a: Vector, _ B: Matrix) -> Matrix {
    return invMatrixVectorOperation(times, a, B)
}

/// Perform vector and matrix multiplication.
///
/// Vector value expands to matrix dimensions (by rows)
/// and elementwise matrix addition is performed.
///
/// Alternatively, `a .* B` can be executed with `times(a, B)`.
///
/// - Parameters
///     - a: vector
///     - B: matrix
/// - Returns: elementwise product of vector a and matrix B
public func .* (_ a: Vector, _ B: Matrix) -> Matrix {
    return times(a, B)
}

/// Perform matrix and vector right division.
///
/// Vector value expands to matrix dimensions (by rows)
/// and elementwise matrix addition is performed.
///
/// Alternatively, `rdivide(A, b)` can be executed with `A ./ b`.
///
/// - Parameters
///     - A: matrix
///     - b: vector
/// - Returns: result of elementwise division of matrix A by vector b
public func rdivide(_ A: Matrix, _ b: Vector) -> Matrix {
    return matrixVectorOperation(rdivide, A, b)
}

/// Perform matrix and vector right division.
///
/// Vector value expands to matrix dimensions (by rows)
/// and elementwise matrix addition is performed.
///
/// Alternatively, `A ./ b` can be executed with `rdivide(A, b)`.
///
/// - Parameters
///     - A: matrix
///     - b: vector
/// - Returns: result of elementwise division of matrix A by vector b
public func ./ (_ A: Matrix, _ b: Vector) -> Matrix {
    return rdivide(A, b)
}

/// Perform vector and matrix right division.
///
/// Vector value expands to matrix dimensions (by rows)
/// and elementwise matrix addition is performed.
///
/// Alternatively, `rdivide(a, B)` can be executed with `a ./ B`.
///
/// - Parameters
///     - a: vector
///     - B: matrix
/// - Returns: result of elementwise division of vector a by matrix B
public func rdivide(_ a: Vector, _ B: Matrix) -> Matrix {
    return invMatrixVectorOperation(rdivide, a, B)
}

/// Perform vector and matrix right division.
///
/// Vector value expands to matrix dimensions (by rows)
/// and elementwise matrix addition is performed.
///
/// Alternatively, `a ./ B` can be executed with `rdivide(a, B)`.
///
/// - Parameters
///     - a: vector
///     - B: matrix
/// - Returns: result of elementwise division of vector a by matrix B
public func ./ (_ a: Vector, _ B: Matrix) -> Matrix {
    return rdivide(a, B)
}

/// Perform matrix and vector left division.
///
/// Vector value expands to matrix dimensions (by rows)
/// and elementwise matrix addition is performed.
///
/// Alternatively, `ldivide(A, b)` can be executed with `A ./. b`.
///
/// - Parameters
///     - A: matrix
///     - b: vector
/// - Returns: result of elementwise division of vector b by matrix A
public func ldivide(_ A: Matrix, _ b: Vector) -> Matrix {
    return matrixVectorOperation(ldivide, A, b)
}

/// Perform matrix and vector left division.
///
/// Vector value expands to matrix dimensions (by rows)
/// and elementwise matrix addition is performed.
///
/// Alternatively, `A ./. b` can be executed with `ldivide(A, b)`.
///
/// - Parameters
///     - A: matrix
///     - b: vector
/// - Returns: result of elementwise division of vector b by matrix A
public func ./. (_ A: Matrix, _ b: Vector) -> Matrix {
    return ldivide(A, b)
}

/// Perform vector and matrix left division.
///
/// Vector value expands to matrix dimensions (by rows)
/// and elementwise matrix addition is performed.
///
/// Alternatively, `ldivide(a, B)` can be executed with `a ./. B`.
///
/// - Parameters
///     - a: vector
///     - B: matrix
/// - Returns: result of elementwise division of matrix B by vector a
public func ldivide(_ a: Vector, _ B: Matrix) -> Matrix {
    return invMatrixVectorOperation(ldivide, a, B)
}

/// Perform vector and matrix left division.
///
/// Vector value expands to matrix dimensions (by rows)
/// and elementwise matrix addition is performed.
///
/// Alternatively, `a ./. B` can be executed with `ldivide(a, B)`.
///
/// - Parameters
///     - a: vector
///     - B: matrix
/// - Returns: result of elementwise division of matrix B by vector a
public func ./. (_ a: Vector, _ B: Matrix) -> Matrix {
    return ldivide(a, B)
}

// MARK: - Sign operations on matrix

/// Absolute value of matrix.
///
/// - Parameters
///     - A: matrix
/// - Returns: matrix of absolute values of elements of matrix A
public func abs(_ A: Matrix) -> Matrix {
    return matrixFunction(abs, A)
}

/// Negation of matrix.
///
/// Alternatively, `uminus(A)` can be executed with `-A`.
///
/// - Parameters
///     - A: matrix
/// - Returns: matrix of negated values of elements of matrix A
public func uminus(_ A: Matrix) -> Matrix {
    return matrixFunction(uminus, A)
}

/// Negation of matrix.
///
/// Alternatively, `-A` can be executed with `uminus(A)`.
///
/// - Parameters
///     - A: matrix
/// - Returns: matrix of negated values of elements of matrix A
public prefix func - (_ A: Matrix) -> Matrix {
    return uminus(A)
}

/// Threshold function on matrix.
///
/// - Parameters
///     - A: matrix
/// - Returns: matrix with values less than certain value set to 0
///            and keeps the value otherwise
public func thr(_ A: Matrix, _ t: Double) -> Matrix {
    return Matrix(A.rows, A.cols, thr(A.flat, t))
}
