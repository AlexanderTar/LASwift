// MatrixTrigonometry.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

// MARK: - Trigonometric functions on matrix

public func sin(_ A: Matrix) -> Matrix {
    return matrixFunction(sin, A)
}

public func cos(_ A: Matrix) -> Matrix {
    return matrixFunction(cos, A)
}

public func tan(_ A: Matrix) -> Matrix {
    return matrixFunction(tan, A)
}
