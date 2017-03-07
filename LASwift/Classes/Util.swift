// Util.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//
// * Redistributions in binary form must reproduce the above
// copyright notice, this list of conditions and the following
// disclaimer in the documentation and/or other materials provided
// with the distribution.
//
// * Neither the name of Alexander Taraymovich nor the names of other
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import Accelerate

// MARK: - Vector operations

typealias Scalar = Double

typealias VectorVectorOperation<T> = ((_: UnsafePointer<T>, _: vDSP_Stride, _: UnsafePointer<T>, _: vDSP_Stride, _: UnsafeMutablePointer<T>, _: vDSP_Stride, _: vDSP_Length) -> ())
where T: FloatingPoint, T: ExpressibleByFloatLiteral

func vectorOperation<T>(_ op: VectorVectorOperation<T>, _ a: [T], _ b: [T]) -> [T]
    where T: FloatingPoint, T: ExpressibleByFloatLiteral {
        precondition(a.count == b.count, "Vectors must have equal lenghts")
        var c = [T](repeating: 0.0, count: a.count)
        op(a, 1, b, 1, &c, 1, vDSP_Length(a.count))
        return c
}

typealias VectorScalarOperation<T> = ((_: UnsafePointer<T>, _: vDSP_Stride, _: UnsafePointer<T>, _: UnsafeMutablePointer<T>, _: vDSP_Stride, _: vDSP_Length) -> ())
where T: FloatingPoint, T: ExpressibleByFloatLiteral

func scalarOperation<T>(_ op: VectorScalarOperation<T>, _ a: [T], _ b: T) -> [T]
    where T: FloatingPoint, T: ExpressibleByFloatLiteral {
        var c = [T](repeating: 0.0, count: a.count)
        var b = b
        op(a, 1, &b, &c, 1, vDSP_Length(a.count))
        return c
}

typealias UnaryVectorOperation<T> = ((_: UnsafePointer<T>, _: vDSP_Stride, _: UnsafeMutablePointer<T>, _: vDSP_Stride, _: vDSP_Length) -> ())
where T: FloatingPoint, T: ExpressibleByFloatLiteral

func unaryOperation<T>(_ op: UnaryVectorOperation<T>, _ a: [T]) -> [T]
    where T: FloatingPoint, T: ExpressibleByFloatLiteral {
        var c = [T](repeating: 0.0, count: a.count)
        op(a, 1, &c, 1, vDSP_Length(a.count))
        return c
}

typealias UnaryVectorFunction<T> = ((_: UnsafeMutablePointer<T>, _: UnsafePointer<T>, _: UnsafePointer<Int32>) -> ())
where T: FloatingPoint, T: ExpressibleByFloatLiteral

func unaryFunction<T>(_ op: UnaryVectorFunction<T>, _ a: [T]) -> [T]
    where T: FloatingPoint, T: ExpressibleByFloatLiteral {
        var c = [T](repeating: 0.0, count: a.count)
        var l = Int32(a.count)
        op(&c, a, &l)
        return c
}

typealias UnaryScalarOperation<T> = ((_: UnsafePointer<T>, _: vDSP_Stride, _: UnsafeMutablePointer<T>, _: vDSP_Length) -> ())
where T: FloatingPoint, T: ExpressibleByFloatLiteral

func unaryOperation<T>(_ op: UnaryScalarOperation<T>, _ a: [T]) -> T {
    var c: T = 0.0 as! T
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
