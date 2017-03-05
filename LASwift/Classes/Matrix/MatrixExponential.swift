//
//  Exponential.swift
//  Pods
//
//  Created by Alexander Taraymovich on 04/03/2017.
//
//

// MARK: - Power and exponential functions

public func power(_ A: Matrix, _ b: Double) -> Matrix {
    return scalarOperation(power, A, b)
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
