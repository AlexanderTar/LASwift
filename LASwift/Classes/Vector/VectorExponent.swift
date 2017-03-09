// VectorExponent.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

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
    return unaryVectorOperation(vDSP_vsqD, a)
}

public func sqrt(_ a: Vector) -> Vector {
    return vectorFunction(vvsqrt, a)
}

public func exp(_ a: Vector) -> Vector {
    return vectorFunction(vvexp, a)
}

public func log(_ a: Vector) -> Vector {
    return vectorFunction(vvlog, a)
}

public func log2(_ a: Vector) -> Vector {
    return vectorFunction(vvlog2, a)
}

public func log10(_ a: Vector) -> Vector {
    return vectorFunction(vvlog10, a)
}
