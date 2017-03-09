// Util.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

import Accelerate

// MARK: - Vector operations

typealias Scalar = Double

typealias VectorVectorOperation = ((_: UnsafePointer<Double>, _: vDSP_Stride, _: UnsafePointer<Double>, _: vDSP_Stride, _: UnsafeMutablePointer<Double>, _: vDSP_Stride, _: vDSP_Length) -> ())

func vectorVectorOperation(_ op: VectorVectorOperation, _ a: Vector, _ b: Vector) -> Vector {
    precondition(a.count == b.count, "Vectors must have equal lenghts")
    var c = Vector(repeating: 0.0, count: a.count)
    op(a, 1, b, 1, &c, 1, vDSP_Length(a.count))
    return c
}

typealias VectorScalarOperation = ((_: UnsafePointer<Double>, _: vDSP_Stride, _: UnsafePointer<Double>, _: UnsafeMutablePointer<Double>, _: vDSP_Stride, _: vDSP_Length) -> ())

func vectorScalarOperation(_ op: VectorScalarOperation, _ a: Vector, _ b: Double) -> Vector {
    var c = Vector(repeating: 0.0, count: a.count)
    var _b = b
    op(a, 1, &_b, &c, 1, vDSP_Length(a.count))
    return c
}

typealias UnaryVectorOperation = ((_: UnsafePointer<Double>, _: vDSP_Stride, _: UnsafeMutablePointer<Double>, _: vDSP_Stride, _: vDSP_Length) -> ())

func unaryVectorOperation(_ op: UnaryVectorOperation, _ a: Vector) -> Vector {
    var c = Vector(repeating: 0.0, count: a.count)
    op(a, 1, &c, 1, vDSP_Length(a.count))
    return c
}

typealias VectorFunction = ((_: UnsafeMutablePointer<Double>, _: UnsafePointer<Double>, _: UnsafePointer<Int32>) -> ())

func vectorFunction(_ op: VectorFunction, _ a: Vector) -> Vector {
    var c = Vector(repeating: 0.0, count: a.count)
    var l = Int32(a.count)
    op(&c, a, &l)
    return c
}

typealias AggVectorFunction = ((_: UnsafePointer<Double>, _: vDSP_Stride, _: UnsafeMutablePointer<Double>, _: vDSP_Length) -> ())

func aggVectorFunction(_ op: AggVectorFunction, _ a: Vector) -> Double {
    var c = 0.0
    op(a, 1, &c, vDSP_Length(a.count))
    return c
}

// MARK: - Matrix operations

typealias MatrixMatrixOperation = ((_ A: Vector, _ B: Vector) -> Vector)

func matrixMatrixOperation(_ op: MatrixMatrixOperation, _ A: Matrix, _ B: Matrix) -> Matrix {
    precondition(A.rows == B.rows && A.cols == B.cols)
    return Matrix(A.rows, A.cols, op(A.flat, B.flat))
}

typealias MatrixScalarOperation = ((_ A: Vector, _ b: Double) -> Vector)

func matrixScalarOperation(_ op: MatrixScalarOperation, _ A: Matrix, _ b: Double) -> Matrix {
    return Matrix(A.rows, A.cols, op(A.flat, b))
}

typealias InvMatrixScalarOperation = ((_ a: Double, _ B: Vector) -> Vector)

func invMatrixScalarOperation(_ op: InvMatrixScalarOperation, _ a: Double, _ B: Matrix) -> Matrix {
    return Matrix(B.rows, B.cols, op(a, B.flat))
}

func matrixVectorOperation(_ op: MatrixMatrixOperation, _ A: Matrix, _ b: Vector) -> Matrix {
    let B = Matrix((0..<A.rows).map { _ -> [Double] in
        return b
    })
    return Matrix(A.rows, A.cols, op(A.flat, B.flat))
}

func invMatrixVectorOperation(_ op: MatrixMatrixOperation, _ a: Vector, _ B: Matrix) -> Matrix {
    let A = Matrix((0..<B.rows).map { _ -> [Double] in
        return a
    })
    return Matrix(B.rows, B.cols, op(A.flat, B.flat))
}

typealias MatrixFunction = ((_ A: Vector) -> Vector)

func matrixFunction(_ op: MatrixFunction, _ A: Matrix) -> Matrix {
    return Matrix(A.rows, A.cols, op(A.flat))
}

typealias AggMatrixFunction = ((_ A: Vector) -> Double)

func aggMatrixFunction(_ op: AggMatrixFunction, _ A: Matrix) -> Vector {
    return (0..<A.cols).map { (i: Int) -> Double in
        var col = A[col:i]
        return op(col)
    }
}
