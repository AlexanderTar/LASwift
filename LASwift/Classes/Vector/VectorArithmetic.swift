//
//  Arithmetic.swift
//  Pods
//
//  Created by Alexander Taraymovich on 23/02/2017.
//
//

import Accelerate

// MARK: - Arithmetic operations on two vectors

public func plus(_ a: Vector, _ b: Vector) -> Vector {
    return vectorOperation(vDSP_vaddD, a, b)
}

public func + (_ a: Vector, _ b: Vector) -> Vector {
    return plus(a, b)
}

public func minus(_ a: Vector, _ b: Vector) -> Vector {
    return vectorOperation(vDSP_vsubD, b, a)
}

public func - (_ a: Vector, _ b: Vector) -> Vector {
    return minus(a, b)
}

public func times(_ a: Vector, _ b: Vector) -> Vector {
    return vectorOperation(vDSP_vmulD, a, b)
}

public func .* (_ a: Vector, _ b: Vector) -> Vector {
    return times(a, b)
}

public func rdivide(_ a: Vector, _ b: Vector) -> Vector {
    return vectorOperation(vDSP_vdivD, b, a)
}

public func ./ (_ a: Vector, _ b: Vector) -> Vector {
    return rdivide(a, b)
}

public func ldivide(_ a: Vector, _ b: Vector) -> Vector {
    return vectorOperation(vDSP_vdivD, a, b)
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
    return scalarOperation(vDSP_vsaddD, a, b)
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
    return scalarOperation(vDSP_vsaddD, a, -b)
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
    return scalarOperation(vDSP_vsmulD, a, b)
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
    return scalarOperation(vDSP_vsdivD, a, b)
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
    return unaryOperation(vDSP_vabsD, a)
}

public func uminus(_ a: Vector) -> Vector {
    return unaryOperation(vDSP_vnegD, a)
}

public prefix func - (_ a: Vector) -> Vector {
    return uminus(a)
}
