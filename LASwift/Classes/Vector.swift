//
//  Vector.swift
//  Pods
//
//  Created by Alexander Taraymovich on 22/02/2017.
//
//

// MARK: - One-line creators for arrays

public func zeros<T>(_ count: Int) -> [T]
    where T: FloatingPoint, T: ExpressibleByFloatLiteral {
        return [T](repeating: 0.0, count: count)
}

public func ones<T>(_ count: Int) -> [T]
    where T: FloatingPoint, T: ExpressibleByFloatLiteral {
        return [T](repeating: 1.0, count: count)
}

public func rand<T>(_ count: Int) -> [T]
    where T: FloatingPoint, T: ExpressibleByFloatLiteral {
        return (1...count).map{_ in Random.generate()}
}
