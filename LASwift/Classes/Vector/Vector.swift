//
//  Vector.swift
//  Pods
//
//  Created by Alexander Taraymovich on 04/03/2017.
//
//

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
