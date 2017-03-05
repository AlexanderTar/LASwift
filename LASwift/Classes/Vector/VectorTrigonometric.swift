//
//  Trigonometric.swift
//  Pods
//
//  Created by Alexander Taraymovich on 04/03/2017.
//
//

import Accelerate

// MARK: - Trigonometric operations on vector

public func sin(_ a: Vector) -> Vector {
    return unaryFunction(vvsin, a)
}

public func cos(_ a: Vector) -> Vector {
    return unaryFunction(vvcos, a)
}

public func tan(_ a: Vector) -> Vector {
    return unaryFunction(vvtan, a)
}
