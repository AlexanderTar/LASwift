// VectorTrigonometry.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

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
