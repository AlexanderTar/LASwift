// Vector.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

// MARK: - One-line creators for vectors

public typealias Vector = [Double]

public func zeros(_ count: Int) -> Vector {
    return Vector(repeating: 0.0, count: count)
}

public func ones(_ count: Int) -> Vector {
    return Vector(repeating: 1.0, count: count)
}

public func rand(_ count: Int) -> Vector {
    return (0..<count).map{_ in Random.generate()}
}

// MARK: - Equatable

public func == (lhs: Vector, rhs: Vector) -> Bool {
    return lhs ==~ rhs
}
