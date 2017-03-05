//
//  Exponentional.swift
//  Pods
//
//  Created by Alexander Taraymovich on 04/03/2017.
//
//

import Accelerate

// MARK: - Power and exponential operations on vector

public func power(_ a: Vector, _ p: Double) -> Vector {
    var c = Vector(repeating: 0.0, count: a.count)
    var l = Int32(a.count)
    var p = p
    vvpows(&c, &p, a, &l)
    return c
}

public func .^ (_ a: Vector, _ p: Double) -> Vector {
    return power(a, p)
}

public func square(_ a: Vector) -> Vector {
    return unaryOperation(vDSP_vsqD, a)
}

public func sqrt(_ a: Vector) -> Vector {
    return unaryFunction(vvsqrt, a)
}

public func exp(_ a: Vector) -> Vector {
    return unaryFunction(vvexp, a)
}

public func log(_ a: Vector) -> Vector {
    return unaryFunction(vvlog, a)
}

public func log2(_ a: Vector) -> Vector {
    return unaryFunction(vvlog2, a)
}

public func log10(_ a: Vector) -> Vector {
    return unaryFunction(vvlog10, a)
}
