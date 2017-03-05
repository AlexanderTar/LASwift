//
//  Statistic.swift
//  Pods
//
//  Created by Alexander Taraymovich on 04/03/2017.
//
//

import Accelerate

// MARK: - Statistical operations on vector

public func max(_ a: Vector) -> Double {
    return unaryOperation(vDSP_maxvD, a)
}

public func min(_ a: Vector) -> Double {
    return unaryOperation(vDSP_minvD, a)
}

public func mean(_ a: Vector) -> Double {
    return unaryOperation(vDSP_meanvD, a)
}

public func std(_ a: Vector) -> Double {
    var m: Double = 0.0
    var s: Double = 0.0
    var c = Vector(repeating: 0.0, count: a.count)
    vDSP_normalizeD(a, 1, &c, 1, &m, &s, vDSP_Length(a.count))
    return s
}

public func norm(_ a: Vector) -> Vector {
    var m: Double = 0.0
    var s: Double = 0.0
    var c = Vector(repeating: 0.0, count: a.count)
    vDSP_normalizeD(a, 1, &c, 1, &m, &s, vDSP_Length(a.count))
    return c
}
