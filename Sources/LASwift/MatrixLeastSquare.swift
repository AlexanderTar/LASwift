// MatrixLeastSquare.swift
//
// Created by Brett Larson on 9/10/20.
// Copyright (c) 2020 Brett Larson
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

#if canImport(Accelerate)
import Accelerate
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#endif
import CLASwiftLAPACK

/// Compute the least squares solution to the overdetermined linear
/// system A*X = B with full rank matrix A.
///
///    A precondition errors throw for mismatched matrix dimensions
///    or if algorithm fails.
///
///    Requires M (rows of A) >= N (cols of A).
///
/// - Parameters:
///     - A: MxN matrix
///     - B: MxK matrix
/// - Returns:
///     - X: NxK solution matrix
///     - R: 1xK residuals
public func lstsqr(_ A: Matrix, _ B: Matrix) -> (X: Matrix, R: Matrix) {
    precondition(A.rows >= A.cols, "A Matrix needs rows >= col")
    precondition(A.rows == B.rows, "A and B Matrix rows must be equal")
    
    // Copies of input that can be modified.
    // In the Intel example of dgels() I noticed the flat matrix has elements by rows
    // and then columns thus the next transposes.  I tried changing TRANS to 'T'
    // to eliminate the transpose but could not find the correct set of other changes
    // to produce the correct solution.
    var at = Matrix(A.T)
    var bt = Matrix(B.T)
    
    var TRANS: Int8 = Int8(Array("N".utf8).first!)  // No transpose
    var M = Int(A.rows)
    var N = Int(A.cols)
    var NRHS = Int(B.cols)
    var LDA = M
    var LDB = M
    
    var wkOpt = Double(0.0)
    var lWork = Int(-1)
    
    var info: Int = 0
 
    /* Query and allocate the optimal workspace */
    laswift_dgels(&TRANS, &M, &N, &NRHS, &(at.flat), &LDA, &(bt.flat), &LDB, &wkOpt, &lWork, &info);
    
    precondition(info == 0, "Error finding optimal lWork")
    lWork = Int(wkOpt)
    var work = Vector(repeating: 0.0, count: Int(lWork))
    
    /* Compute least square solution */
    laswift_dgels(&TRANS, &M, &N, &NRHS, &(at.flat), &LDA, &(bt.flat), &LDB, &work, &lWork, &info);
    
    precondition(info == 0, "Error")
    
    let X = bt.T[0..<Int(N), 0..<Int(NRHS)]
    var R = zeros(1, Int(NRHS))
    for i in 0..<Int(NRHS) {
        var norm = 0.0
        for j in 0..<Int(M-N) {
            let x: Double = bt[i, Int(N)+j]
            norm += x*x
        }
        R[0, i] = norm
    }
    
    return (X, R)
}

/*
 Is there a problem defining Vector = [Double] = Array<Double> and
 passing dereferenced address with & to LAPACK function?  See the
 description for ContiguousArray<Element> at:
    <https://developer.apple.com/documentation/swift/contiguousarray>
 What I do not know is if "Double" is a class or @objc protocol.  Will
 [Double] have contiguous data that LAPACK requires.
 */

/*
 Reference Intel example of dgels() at:
    <https://software.intel.com/sites/products/documentation/doclib/mkl_sa/11/mkl_lapack_examples/dgels_ex.c.htm>
 This includes a test case with data.
 */

/*
 Reference LAPACK documentation for dgels() at:
    <http://www.netlib.org/lapack/double/dgels.f>
 */
