// Vector.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

import Accelerate

// MARK: - Arithmetic operations on two vectors

public func plus(_ a: Vector, _ b: Vector) -> Vector {
    return vectorVectorOperation(vDSP_vaddD, a, b)
}

public func + (_ a: Vector, _ b: Vector) -> Vector {
    return plus(a, b)
}

public func minus(_ a: Vector, _ b: Vector) -> Vector {
    return vectorVectorOperation(vDSP_vsubD, b, a)
}

public func - (_ a: Vector, _ b: Vector) -> Vector {
    return minus(a, b)
}

public func times(_ a: Vector, _ b: Vector) -> Vector {
    return vectorVectorOperation(vDSP_vmulD, a, b)
}

public func .* (_ a: Vector, _ b: Vector) -> Vector {
    return times(a, b)
}

public func rdivide(_ a: Vector, _ b: Vector) -> Vector {
    return vectorVectorOperation(vDSP_vdivD, b, a)
}

public func ./ (_ a: Vector, _ b: Vector) -> Vector {
    return rdivide(a, b)
}

public func ldivide(_ a: Vector, _ b: Vector) -> Vector {
    return vectorVectorOperation(vDSP_vdivD, a, b)
}

public func ./. (_ a: Vector, _ b: Vector) -> Vector {
    return ldivide(a, b)
}

// MARK: - Dot product operations on two vectors

public func dot(_ a: Vector, _ b: Vector) -> Double {
    precondition(a.count == b.count, "Vectors must have equal lenghts")
    var c: Double = 0.0
    vDSP_dotprD(a, 1, b, 1, &c, vDSP_Length(a.count))
    return c
}

public func * (_ a: Vector, _ b: Vector) -> Double {
    return dot(a, b)
}

// MARK: - Arithmetic operations on vector and scalar

public func plus(_ a: Vector, _ b: Double) -> Vector {
    return vectorScalarOperation(vDSP_vsaddD, a, b)
}

public func + (_ a: Vector, _ b: Double) -> Vector {
    return plus(a, b)
}

public func plus(_ a: Double, _ b: Vector) -> Vector {
    return plus(b, a)
}

public func + (_ a: Double, _ b: Vector) -> Vector {
    return plus(a, b)
}

public func minus(_ a: Vector, _ b: Double) -> Vector {
    return vectorScalarOperation(vDSP_vsaddD, a, -b)
}

public func - (_ a: Vector, _ b: Double) -> Vector {
    return minus(a, b)
}

public func minus(_ a: Double, _ b: Vector) -> Vector {
    return uminus(minus(b, a))
}

public func - (_ a: Double, _ b: Vector) -> Vector {
    return minus(a, b)
}

public func times(_ a: Vector, _ b: Double) -> Vector {
    return vectorScalarOperation(vDSP_vsmulD, a, b)
}

public func .* (_ a: Vector, _ b: Double) -> Vector {
    return times(a, b)
}

public func times(_ a: Double, _ b: Vector) -> Vector {
    return times(b, a)
}

public func .* (_ a: Double, _ b: Vector) -> Vector {
    return times(a, b)
}

public func rdivide(_ a: Vector, _ b: Double) -> Vector {
    return vectorScalarOperation(vDSP_vsdivD, a, b)
}

public func ./ (_ a: Vector, _ b: Double) -> Vector {
    return rdivide(a, b)
}

public func rdivide(_ a: Double, _ b: Vector) -> Vector {
    var c = Vector(repeating: a, count: b.count)
    return rdivide(c, b)
}

public func ./ (_ a: Double, _ b: Vector) -> Vector {
    return rdivide(a, b)
}

public func ldivide(_ a: Vector, _ b: Double) -> Vector {
    return rdivide(b, a)
}

public func ./. (_ a: Vector, _ b: Double) -> Vector {
    return ldivide(a, b)
}

public func ldivide(_ a: Double, _ b: Vector) -> Vector {
    return rdivide(b, a)
}

public func ./. (_ a: Double, _ b: Vector) -> Vector {
    return ldivide(a, b)
}

// MARK: - Sign operations on vector

public func abs(_ a: Vector) -> Vector {
    return unaryVectorOperation(vDSP_vabsD, a)
}

public func uminus(_ a: Vector) -> Vector {
    return unaryVectorOperation(vDSP_vnegD, a)
}

public prefix func - (_ a: Vector) -> Vector {
    return uminus(a)
}
