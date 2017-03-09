// VectorStatistics.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

import Accelerate

// MARK: - Statistical operations on vector

public func max(_ a: Vector) -> Double {
    return aggVectorFunction(vDSP_maxvD, a)
}

public func min(_ a: Vector) -> Double {
    return aggVectorFunction(vDSP_minvD, a)
}

public func mean(_ a: Vector) -> Double {
    return aggVectorFunction(vDSP_meanvD, a)
}

public func std(_ a: Vector) -> Double {
    var m: Double = 0.0
    var s: Double = 0.0
    var c = Vector(repeating: 0.0, count: a.count)
    vDSP_normalizeD(a, 1, &c, 1, &m, &s, vDSP_Length(a.count))
    return s
}

public func normalize(_ a: Vector) -> Vector {
    var m: Double = 0.0
    var s: Double = 0.0
    var c = Vector(repeating: 0.0, count: a.count)
    vDSP_normalizeD(a, 1, &c, 1, &m, &s, vDSP_Length(a.count))
    return c
}

public func sum(_ a: Vector) -> Double {
    return aggVectorFunction(vDSP_sveD, a)
}

public func sumsq(_ a: Vector) -> Double {
    return aggVectorFunction(vDSP_svesqD, a)
}
