// MatrixExponent.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

// MARK: - Power and exponential functions

public func power(_ A: Matrix, _ b: Double) -> Matrix {
    return matrixScalarOperation(power, A, b)
}

public func .^ (_ a: Matrix, _ p: Double) -> Matrix {
    return power(a, p)
}

public func square(_ A: Matrix) -> Matrix {
    return matrixFunction(square, A)
}

public func sqrt(_ A: Matrix) -> Matrix {
    return matrixFunction(sqrt, A)
}

public func exp(_ A: Matrix) -> Matrix {
    return matrixFunction(exp, A)
}

public func log(_ A: Matrix) -> Matrix {
    return matrixFunction(log, A)
}

public func log2(_ A: Matrix) -> Matrix {
    return matrixFunction(log2, A)
}

public func log10(_ A: Matrix) -> Matrix {
    return matrixFunction(log10, A)
}
