// Vector.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

import Darwin
import Accelerate

// MARK: - Arithmetic operations on two vectors

/// Perform vector addition.
///
/// Alternatively, `plus(a, b)` can be executed with `a + b`.
///
/// - Parameters
///     - a: left vector
///     - b: right vector
/// - Returns: elementwise vector sum of a and b
public func plus(_ a: Vector, _ b: Vector) -> Vector {
    return vectorVectorOperation(vDSP_vaddD, a, b)
}

/// Perform vector addition.
///
/// Alternatively, `a + b` can be executed with `plus(a, b)`.
///
/// - Parameters
///     - a: left vector
///     - b: right vector
/// - Returns: elementwise vector sum of a and b
public func + (_ a: Vector, _ b: Vector) -> Vector {
    return plus(a, b)
}

/// Perform vector substraction.
///
/// Alternatively, `minus(a, b)` can be executed with `a - b`.
///
/// - Parameters
///     - a: left vector
///     - b: right vector
/// - Returns: elementwise vector difference of a and b
public func minus(_ a: Vector, _ b: Vector) -> Vector {
    return vectorVectorOperation(vDSP_vsubD, b, a)
}

/// Perform vector substraction.
///
/// Alternatively, `a - b` can be executed with `minus(a, b)`.
///
/// - Parameters
///     - a: left vector
///     - b: right vector
/// - Returns: elementwise vector difference of a and b
public func - (_ a: Vector, _ b: Vector) -> Vector {
    return minus(a, b)
}

/// Perform vector multiplication.
///
/// Alternatively, `times(a, b)` can be executed with `a .* b`.
///
/// - Parameters
///     - a: left vector
///     - b: right vector
/// - Returns: elementwise vector product of a and b
public func times(_ a: Vector, _ b: Vector) -> Vector {
    return vectorVectorOperation(vDSP_vmulD, a, b)
}

/// Perform vector multiplication.
///
/// Alternatively, `a .* b` can be executed with `times(a, b)`.
///
/// - Parameters
///     - a: left vector
///     - b: right vector
/// - Returns: elementwise vector product of a and b
public func .* (_ a: Vector, _ b: Vector) -> Vector {
    return times(a, b)
}

/// Perform vector right division.
///
/// Alternatively, `rdivide(a, b)` can be executed with `a ./ b`.
///
/// - Parameters
///     - a: left vector
///     - b: right vector
/// - Returns: result of elementwise division of a by b
public func rdivide(_ a: Vector, _ b: Vector) -> Vector {
    return vectorVectorOperation(vDSP_vdivD, b, a)
}

/// Perform vector right division.
///
/// Alternatively, `a ./ b` can be executed with `rdivide(a, b)`.
///
/// - Parameters
///     - a: left vector
///     - b: right vector
/// - Returns: result of elementwise division of a by b
public func ./ (_ a: Vector, _ b: Vector) -> Vector {
    return rdivide(a, b)
}

/// Perform vector left division.
///
/// Alternatively, `ldivide(a, b)` can be executed with `a ./. b`.
///
/// - Parameters
///     - a: left vector
///     - b: right vector
/// - Returns: result of elementwise division of b by a
public func ldivide(_ a: Vector, _ b: Vector) -> Vector {
    return vectorVectorOperation(vDSP_vdivD, a, b)
}

/// Perform vector left division.
///
/// Alternatively, `a ./. b` can be executed with `ldivide(a, b)`.
///
/// - Parameters
///     - a: left vector
///     - b: right vector
/// - Returns: result of elementwise division of b by a
public func ./. (_ a: Vector, _ b: Vector) -> Vector {
    return ldivide(a, b)
}

// MARK: - Dot product operations on two vectors

/// Perform vector dot product operation.
///
/// Alternatively, `dot(a, b)` can be executed with `a * b`.
///
/// - Parameters
///     - a: left vector
///     - b: right vector
/// - Returns: dot product of a and b
public func dot(_ a: Vector, _ b: Vector) -> Double {
    precondition(a.count == b.count, "Vectors must have equal lenghts")
    var c: Double = 0.0
    vDSP_dotprD(a, 1, b, 1, &c, vDSP_Length(a.count))
    return c
}

/// Perform vector dot product operation.
///
/// Alternatively, `a * b` can be executed with `dot(a, b)`.
///
/// - Parameters
///     - a: left vector
///     - b: right vector
/// - Returns: dot product of a and b
public func * (_ a: Vector, _ b: Vector) -> Double {
    return dot(a, b)
}

// MARK: - Arithmetic operations on vector and scalar

/// Perform vector and scalar addition.
///
/// Scalar value expands to vector dimension 
/// and elementwise vector addition is performed.
///
/// Alternatively, `plus(a, b)` can be executed with `a + b`.
///
/// - Parameters
///     - a: vector
///     - b: scalar
/// - Returns: elementwise sum of vector a and scalar b
public func plus(_ a: Vector, _ b: Double) -> Vector {
    return vectorScalarOperation(vDSP_vsaddD, a, b)
}

/// Perform vector and scalar addition.
///
/// Scalar value expands to vector dimension
/// and elementwise vector addition is performed.
///
/// Alternatively, `a + b` can be executed with `plus(a, b)`.
///
/// - Parameters
///     - a: vector
///     - b: scalar
/// - Returns: elementwise sum of vector a and scalar b
public func + (_ a: Vector, _ b: Double) -> Vector {
    return plus(a, b)
}

/// Perform scalar and vector addition.
///
/// Scalar value expands to vector dimension
/// and elementwise vector addition is performed.
///
/// Alternatively, `plus(a, b)` can be executed with `a + b`.
///
/// - Parameters
///     - a: scalar
///     - b: vector
/// - Returns: elementwise sum of scalar a and vector b
public func plus(_ a: Double, _ b: Vector) -> Vector {
    return plus(b, a)
}

/// Perform scalar and vector addition.
///
/// Scalar value expands to vector dimension
/// and elementwise vector addition is performed.
///
/// Alternatively, `a + b` can be executed with `plus(a, b)`.
///
/// - Parameters
///     - a: scalar
///     - b: vector
/// - Returns: elementwise sum of scalar a and vector b
public func + (_ a: Double, _ b: Vector) -> Vector {
    return plus(a, b)
}

/// Perform vector and scalar substraction.
///
/// Scalar value expands to vector dimension
/// and elementwise vector substraction is performed.
///
/// Alternatively, `minus(a, b)` can be executed with `a - b`.
///
/// - Parameters
///     - a: vector
///     - b: scalar
/// - Returns: elementwise difference of vector a and scalar b
public func minus(_ a: Vector, _ b: Double) -> Vector {
    return vectorScalarOperation(vDSP_vsaddD, a, -b)
}

/// Perform vector and scalar substraction.
///
/// Scalar value expands to vector dimension
/// and elementwise vector substraction is performed.
///
/// Alternatively, `a - b` can be executed with `minus(a, b)`.
///
/// - Parameters
///     - a: vector
///     - b: scalar
/// - Returns: elementwise difference of vector a and scalar b
public func - (_ a: Vector, _ b: Double) -> Vector {
    return minus(a, b)
}

/// Perform scalar and vector substraction.
///
/// Scalar value expands to vector dimension
/// and elementwise vector addition is performed.
///
/// Alternatively, `minus(a, b)` can be executed with `a - b`.
///
/// - Parameters
///     - a: scalar
///     - b: vector
/// - Returns: elementwise difference of scalar a and vector b
public func minus(_ a: Double, _ b: Vector) -> Vector {
    return uminus(minus(b, a))
}

/// Perform scalar and vector substraction.
///
/// Scalar value expands to vector dimension
/// and elementwise vector addition is performed.
///
/// Alternatively, `a - b` can be executed with `minus(a, b)`.
///
/// - Parameters
///     - a: scalar
///     - b: vector
/// - Returns: elementwise difference of scalar a and vector b
public func - (_ a: Double, _ b: Vector) -> Vector {
    return minus(a, b)
}

/// Perform vector and scalar multiplication.
///
/// Scalar value expands to vector dimension
/// and elementwise vector multiplication is performed.
///
/// Alternatively, `times(a, b)` can be executed with `a .* b`.
///
/// - Parameters
///     - a: vector
///     - b: scalar
/// - Returns: elementwise product of vector a and scalar b
public func times(_ a: Vector, _ b: Double) -> Vector {
    return vectorScalarOperation(vDSP_vsmulD, a, b)
}

/// Perform vector and scalar multiplication.
///
/// Scalar value expands to vector dimension
/// and elementwise vector multiplication is performed.
///
/// Alternatively, `a .* b` can be executed with `times(a, b)`.
///
/// - Parameters
///     - a: vector
///     - b: scalar
/// - Returns: elementwise product of vector a and scalar b
public func .* (_ a: Vector, _ b: Double) -> Vector {
    return times(a, b)
}

/// Perform scalar and vector multiplication.
///
/// Scalar value expands to vector dimension
/// and elementwise vector multiplication is performed.
///
/// Alternatively, `times(a, b)` can be executed with `a .* b`.
///
/// - Parameters
///     - a: scalar
///     - b: vector
/// - Returns: elementwise product of scalar a and vector b
public func times(_ a: Double, _ b: Vector) -> Vector {
    return times(b, a)
}

/// Perform scalar and vector multiplication.
///
/// Scalar value expands to vector dimension
/// and elementwise vector multiplication is performed.
///
/// Alternatively, `a .* b` can be executed with `times(a, b)`.
///
/// - Parameters
///     - a: scalar
///     - b: vector
/// - Returns: elementwise product of scalar a and vector b
public func .* (_ a: Double, _ b: Vector) -> Vector {
    return times(a, b)
}

/// Perform vector and scalar right division.
///
/// Scalar value expands to vector dimension
/// and elementwise vector right division is performed.
///
/// Alternatively, `rdivide(a, b)` can be executed with `a ./ b`.
///
/// - Parameters
///     - a: vector
///     - b: scalar
/// - Returns: result of elementwise division of vector a by scalar b
public func rdivide(_ a: Vector, _ b: Double) -> Vector {
    return vectorScalarOperation(vDSP_vsdivD, a, b)
}

/// Perform vector and scalar right division.
///
/// Scalar value expands to vector dimension
/// and elementwise vector right division is performed.
///
/// Alternatively, `a ./ b` can be executed with `rdivide(a, b)`.
///
/// - Parameters
///     - a: vector
///     - b: scalar
/// - Returns: result of elementwise division of vector a by scalar b
public func ./ (_ a: Vector, _ b: Double) -> Vector {
    return rdivide(a, b)
}

/// Perform scalar and vector right division.
///
/// Scalar value expands to vector dimension
/// and elementwise vector right division is performed.
///
/// Alternatively, `rdivide(a, b)` can be executed with `a ./ b`.
///
/// - Parameters
///     - a: scalar
///     - b: vector
/// - Returns: result of elementwise division of scalar a by vector b
public func rdivide(_ a: Double, _ b: Vector) -> Vector {
    let c = Vector(repeating: a, count: b.count)
    return rdivide(c, b)
}

/// Perform scalar and vector right division.
///
/// Scalar value expands to vector dimension
/// and elementwise vector right division is performed.
///
/// Alternatively, `a ./ b` can be executed with `rdivide(a, b)`.
///
/// - Parameters
///     - a: scalar
///     - b: vector
/// - Returns: result of elementwise division of scalar a by vector b
public func ./ (_ a: Double, _ b: Vector) -> Vector {
    return rdivide(a, b)
}

/// Perform vector and scalar left division.
///
/// Scalar value expands to vector dimension
/// and elementwise vector left division is performed.
///
/// Alternatively, `ldivide(a, b)` can be executed with `a ./. b`.
///
/// - Parameters
///     - a: vector
///     - b: scalar
/// - Returns: result of elementwise division of scalar b by vector a
public func ldivide(_ a: Vector, _ b: Double) -> Vector {
    return rdivide(b, a)
}

/// Perform vector and scalar left division.
///
/// Scalar value expands to vector dimension
/// and elementwise vector left division is performed.
///
/// Alternatively, `a ./. b` can be executed with `ldivide(a, b)`.
///
/// - Parameters
///     - a: vector
///     - b: scalar
/// - Returns: result of elementwise division of scalar b by vector a
public func ./. (_ a: Vector, _ b: Double) -> Vector {
    return ldivide(a, b)
}

/// Perform scalar and vector left division.
///
/// Scalar value expands to vector dimension
/// and elementwise vector left division is performed.
///
/// Alternatively, `ldivide(a, b)` can be executed with `a ./. b`.
///
/// - Parameters
///     - a: scalar
///     - b: vector
/// - Returns: result of elementwise division of vector b by scalar a
public func ldivide(_ a: Double, _ b: Vector) -> Vector {
    return rdivide(b, a)
}

/// Perform scalar and vector left division.
///
/// Scalar value expands to vector dimension
/// and elementwise vector left division is performed.
///
/// Alternatively, `a ./. b` can be executed with `ldivide(a, b)`.
///
/// - Parameters
///     - a: scalar
///     - b: vector
/// - Returns: result of elementwise division of vector b by scalar a
public func ./. (_ a: Double, _ b: Vector) -> Vector {
    return ldivide(a, b)
}

// MARK: - Sign operations on vector

/// Absolute value of vector.
///
/// - Parameters
///     - a: vector
/// - Returns: vector of absolute values of elements of vector a
public func abs(_ a: Vector) -> Vector {
    return unaryVectorOperation(vDSP_vabsD, a)
}

/// Negation of vector.
///
/// Alternatively, `uminus(a)` can be executed with `-a`.
///
/// - Parameters
///     - a: vector
/// - Returns: vector of negated values of elements of vector a
public func uminus(_ a: Vector) -> Vector {
    return unaryVectorOperation(vDSP_vnegD, a)
}

/// Negation of vector.
///
/// Alternatively, `-a` can be executed with `uminus(a)`.
///
/// - Parameters
///     - a: vector
/// - Returns: vector of negated values of elements of vector a
public prefix func - (_ a: Vector) -> Vector {
    return uminus(a)
}

/// Threshold function on vector.
///
/// - Parameters
///     - a: vector
/// - Returns: vector with values less than certain value set to 0 
///            and keeps the value otherwise
public func thr(_ a: Vector, _ t: Double) -> Vector {
    var b = zeros(a.count)
    var t = t
    vDSP_vthrD(a, 1, &t, &b, 1, vDSP_Length(a.count))
    return b
}
