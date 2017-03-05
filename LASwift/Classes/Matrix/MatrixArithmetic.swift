//
//  Arithmetic.swift
//  Pods
//
//  Created by Alexander Taraymovich on 04/03/2017.
//
//

// MARK: - Matrix-Matrix arithmetics

public func plus(_ A: Matrix, _ B: Matrix) -> Matrix {
    return matrixOperation(plus, A, B)
}

public func + (_ A: Matrix, _ B: Matrix) -> Matrix {
    return plus(A, B)
}

public func minus(_ A: Matrix, _ B: Matrix) -> Matrix {
    return matrixOperation(minus, A, B)
}

public func - (_ A: Matrix, _ B: Matrix) -> Matrix {
    return minus(A, B)
}

public func times(_ A: Matrix, _ B: Matrix) -> Matrix {
    return matrixOperation(times, A, B)
}

public func .* (_ A: Matrix, _ B: Matrix) -> Matrix {
    return times(A, B)
}

public func rdivide(_ A: Matrix, _ B: Matrix) -> Matrix {
    return matrixOperation(rdivide, A, B)
}

public func ./ (_ A: Matrix, _ B: Matrix) -> Matrix {
    return rdivide(A, B)
}

public func ldivide(_ A: Matrix, _ B: Matrix) -> Matrix {
    return matrixOperation(ldivide, A, B)
}

public func ./. (_ A: Matrix, _ B: Matrix) -> Matrix {
    return ldivide(A, B)
}

// MARK: - Matrix-Scalar arithmetics

public func plus(_ A: Matrix, _ b: Double) -> Matrix {
    return scalarOperation(plus, A, b)
}

public func + (_ A: Matrix, _ b: Double) -> Matrix {
    return plus(A, b)
}

public func plus(_ a: Double, _ B: Matrix) -> Matrix {
    return invScalarOperation(plus, a, B)
}

public func + (_ a: Double, _ B: Matrix) -> Matrix {
    return plus(a, B)
}

public func minus(_ A: Matrix, _ b: Double) -> Matrix {
    return scalarOperation(minus, A, b)
}

public func - (_ A: Matrix, _ b: Double) -> Matrix {
    return minus(A, b)
}

public func minus(_ a: Double, _ B: Matrix) -> Matrix {
    return invScalarOperation(minus, a, B)
}

public func - (_ a: Double, _ B: Matrix) -> Matrix {
    return minus(a, B)
}

public func times(_ A: Matrix, _ b: Double) -> Matrix {
    return scalarOperation(times, A, b)
}

public func .* (_ A: Matrix, _ b: Double) -> Matrix {
    return times(A, b)
}

public func times(_ a: Double, _ B: Matrix) -> Matrix {
    return invScalarOperation(times, a, B)
}

public func .* (_ a: Double, _ B: Matrix) -> Matrix {
    return times(a, B)
}

public func rdivide(_ A: Matrix, _ b: Double) -> Matrix {
    return scalarOperation(rdivide, A, b)
}

public func ./ (_ A: Matrix, _ b: Double) -> Matrix {
    return rdivide(A, b)
}

public func rdivide(_ a: Double, _ B: Matrix) -> Matrix {
    return invScalarOperation(rdivide, a, B)
}

public func ./ (_ a: Double, _ B: Matrix) -> Matrix {
    return rdivide(a, B)
}

public func ldivide(_ A: Matrix, _ b: Double) -> Matrix {
    return scalarOperation(ldivide, A, b)
}

public func ./. (_ A: Matrix, _ b: Double) -> Matrix {
    return ldivide(A, b)
}

public func ldivide(_ a: Double, _ B: Matrix) -> Matrix {
    return invScalarOperation(ldivide, a, B)
}

public func ./. (_ a: Double, _ B: Matrix) -> Matrix {
    return ldivide(a, B)
}

// MARK: - Matrix-Vector arithmetics

public func plus(_ A: Matrix, _ b: Vector) -> Matrix {
    return matrixVectorOperation(plus, A, b)
}

public func + (_ A: Matrix, _ b: Vector) -> Matrix {
    return plus(A, b)
}

public func plus(_ a: Vector, _ B: Matrix) -> Matrix {
    return invMatrixVectorOperation(plus, a, B)
}

public func + (_ a: Vector, _ B: Matrix) -> Matrix {
    return plus(a, B)
}

public func minus(_ A: Matrix, _ b: Vector) -> Matrix {
    return matrixVectorOperation(minus, A, b)
}

public func - (_ A: Matrix, _ b: Vector) -> Matrix {
    return minus(A, b)
}

public func minus(_ a: Vector, _ B: Matrix) -> Matrix {
    return invMatrixVectorOperation(minus, a, B)
}

public func - (_ a: Vector, _ B: Matrix) -> Matrix {
    return minus(a, B)
}

public func times(_ A: Matrix, _ b: Vector) -> Matrix {
    return matrixVectorOperation(times, A, b)
}

public func .* (_ A: Matrix, _ b: Vector) -> Matrix {
    return times(A, b)
}

public func times(_ a: Vector, _ B: Matrix) -> Matrix {
    return invMatrixVectorOperation(times, a, B)
}

public func .* (_ a: Vector, _ B: Matrix) -> Matrix {
    return times(a, B)
}

public func rdivide(_ A: Matrix, _ b: Vector) -> Matrix {
    return matrixVectorOperation(rdivide, A, b)
}

public func ./ (_ A: Matrix, _ b: Vector) -> Matrix {
    return rdivide(A, b)
}

public func rdivide(_ a: Vector, _ B: Matrix) -> Matrix {
    return invMatrixVectorOperation(rdivide, a, B)
}

public func ./ (_ a: Vector, _ B: Matrix) -> Matrix {
    return rdivide(a, B)
}

public func ldivide(_ A: Matrix, _ b: Vector) -> Matrix {
    return matrixVectorOperation(ldivide, A, b)
}

public func ./. (_ A: Matrix, _ b: Vector) -> Matrix {
    return ldivide(A, b)
}

public func ldivide(_ a: Vector, _ B: Matrix) -> Matrix {
    return invMatrixVectorOperation(ldivide, a, B)
}

public func ./. (_ a: Vector, _ B: Matrix) -> Matrix {
    return ldivide(a, B)
}

// MARK: - Sign operations on matrix

public func abs(_ A: Matrix) -> Matrix {
    return matrixFunction(abs, A)
}

public func uminus(_ A: Matrix) -> Matrix {
    return matrixFunction(uminus, A)
}

public prefix func - (_ a: Matrix) -> Matrix {
    return uminus(a)
}
