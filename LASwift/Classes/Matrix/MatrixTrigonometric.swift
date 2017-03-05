//
//  Trigonometric.swift
//  Pods
//
//  Created by Alexander Taraymovich on 04/03/2017.
//
//

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
