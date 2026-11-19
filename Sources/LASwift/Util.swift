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
    return aggVectorFunction(op, a, a.count)
}

func aggVectorFunction(_ op: AggVectorFunction, _ a: UnsafePointer<Double>, _ count: Int) -> Double {
    var c = 0.0
    op(a, 1, &c, vDSP_Length(count))
    return c
}

typealias AggVectorIFunction = ((_: UnsafePointer<Double>, _: vDSP_Stride, _: UnsafeMutablePointer<Double>, _: UnsafeMutablePointer<vDSP_Length>, _: vDSP_Length) -> ())

func aggVectorIFunction(_ op: AggVectorIFunction, _ a: Vector) -> Int {
    return aggVectorIFunction(op, a, a.count)
}

func aggVectorIFunction(_ op: AggVectorIFunction, _ a: UnsafePointer<Double>, _ count: Int) -> Int {
    var c = 0.0
    var i: vDSP_Length = 0
    op(a, 1, &c, &i, vDSP_Length(count))
    return Int(i)
}

// MARK: - Matrix operations

typealias MatrixMatrixOperation = ((_ A: Vector, _ B: Vector) -> Vector)

func matrixMatrixOperation(_ op: MatrixMatrixOperation, _ A: Matrix, _ B: Matrix) -> Matrix {
    precondition(A.rows == B.rows && A.cols == B.cols, "Matrices must be of same dimensions")
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

func aggMatrixFunction(_ op: AggMatrixFunction, _ A: Matrix, _ d: Dim) -> Vector {
    let _A = toRows(A, d)
    var res = zeros(_A.rows)
    for i in (0..<_A.rows) {
        res[i] = op(_A[row: i])
    }
    return res
}

func aggMatrixFunction(_ op: AggVectorFunction, _ A: Matrix, _ d: Dim) -> Vector {
    let _A = toRows(A, d)
    var res = zeros(_A.rows)
    for i in (0..<_A.rows) {
        _A.flat.withUnsafeBufferPointer { bufPtr in
            let p = bufPtr.baseAddress! + i * _A.cols
            res[i] = aggVectorFunction(op, p, _A.cols)
        }
    }
    return res
}

func aggMatrixIFunction(_ op: AggVectorIFunction, _ A: Matrix, _ d: Dim) -> [Int] {
    let _A = toRows(A, d)
    var res = [Int](repeating: 0, count: _A.rows)
    for i in (0..<_A.rows) {
        _A.flat.withUnsafeBufferPointer { bufPtr in
            let p = bufPtr.baseAddress! + i * _A.cols
            res[i] = aggVectorIFunction(op, p, _A.cols)
        }
    }
    return res
}
