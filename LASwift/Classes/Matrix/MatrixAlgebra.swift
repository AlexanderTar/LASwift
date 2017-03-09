// MatrixAlgebra.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

import Accelerate

// MARK: - Linear algebra operations on matrices

public func trace(_ A: Matrix) -> Vector {
    precondition(A.rows == A.cols, "Matrix dimensions must agree")
    return (0..<A.rows).map { A[$0, $0] }
}

public func norm(_ A: Matrix) -> Double {
    return sumsq(trace(A))
}

public func transpose(_ A: Matrix) -> Matrix {
    var C: Matrix = zeros(A.cols, A.rows)
    vDSP_mtransD(A.flat, 1, &(C.flat), 1, vDSP_Length(A.cols), vDSP_Length(A.rows))
    return C
}

public postfix func ′ (_ a: Matrix) -> Matrix {
    return transpose(a)
}

public func mtimes(_ A: Matrix, _ B: Matrix) -> Matrix {
    precondition(A.cols == B.rows, "Matrix dimensions must agree")
    var C: Matrix = zeros(A.rows, B.cols)
    vDSP_mmulD(A.flat, 1, B.flat, 1, &(C.flat), 1, vDSP_Length(A.rows), vDSP_Length(B.cols), vDSP_Length(A.cols))
    return C
}

public func * (_ A: Matrix, _ B: Matrix) -> Matrix {
    return mtimes(A, B)
}

public func mpower(_ A: Matrix, _ p: Int) -> Matrix {
    precondition(A.cols == A.rows, "Matrix dimensions must agree")
    switch p {
    case 1:
        return Matrix(A)
    case -1:
        return inv(A)
    case _ where p > 1:
        var C = Matrix(A)
        var p = p
        while (p > 1) {
            C = mtimes(A, C)
            p -= 1
        }
        return C
    case _ where p < -1:
        return inv(mpower(A, -p))
    default:
        preconditionFailure("Power must be non-zero")
    }
}

public func ^ (_ a: Matrix, _ p: Int) -> Matrix {
    return mpower(a, p)
}

public func inv(_ A: Matrix) -> Matrix {
    precondition(A.rows == A.cols, "Matrix dimensions must agree")
    var B = Matrix(A)
    
    var N = __CLPK_integer(A.rows)
    var pivot = [__CLPK_integer](repeating: 0, count: Int(N))
    
    var wkOpt = __CLPK_doublereal(0.0)
    var lWork = __CLPK_integer(-1)
    
    var error: __CLPK_integer = 0
    
    dgetrf_(&N, &N, &(B.flat), &N, &pivot, &error)
    
    precondition(error == 0, "Matrix is non invertible")
    
    /* Query and allocate the optimal workspace */
    
    dgetri_(&N, &(B.flat), &N, &pivot, &wkOpt, &lWork, &error)
    
    lWork = __CLPK_integer(wkOpt)
    var work = Vector(repeating: 0.0, count: Int(lWork))
    
    /* Compute inversed matrix */
    
    dgetri_(&N, &(B.flat), &N, &pivot, &work, &lWork, &error)
    
    precondition(error == 0, "Matrix is non invertible")
    
    return B
}

public func eig(_ A: Matrix) -> (V: Matrix, D: Matrix) {
    precondition(A.rows == A.cols, "Matrix dimensions must agree")
    
    var V = Matrix(A)
    
    var N = __CLPK_integer(A.rows)
    
    var LDA = N
    
    var wkOpt = __CLPK_doublereal(0.0)
    var lWork = __CLPK_integer(-1)
    
    var liWkOpt = __CLPK_integer(0)
    var liWork = __CLPK_integer(-1)
    
    var jobz: Int8 = 86 // 'V'
    var uplo: Int8 = 85 // 'U'
    
    var error = __CLPK_integer(0)
    
    var eig = Vector(repeating: 0.0, count: Int(N))
    
    /* Query and allocate the optimal workspace */
    
    dsyevd_(&jobz, &uplo, &N, &V.flat, &LDA, &eig, &wkOpt, &lWork, &liWkOpt, &liWork, &error)
    
    lWork = __CLPK_integer(wkOpt)
    var work = Vector(repeating: 0.0, count: Int(lWork))
    
    liWork = liWkOpt
    var iWork = [__CLPK_integer](repeating: 0, count: Int(liWork))
    
    /* Compute eigen vectors */
    
    dsyevd_(&jobz, &uplo, &N, &V.flat, &LDA, &eig, &work, &lWork, &iWork, &liWork, &error)
    
    precondition(error == 0, "Failed to compute eigen vectors")
    
    return (transpose(V), diag(eig))
}

public func svd(_ A: Matrix) -> (U: Matrix, S: Matrix, V: Matrix) {
    /* LAPACK is using column-major order */
    var _A = transpose(A)
    
    var jobz: Int8 = 65 // 'A'
    
    var M = __CLPK_integer(A.rows);
    var N = __CLPK_integer(A.cols);
    
    var LDA = M;
    var LDU = M;
    var LDVT = N;
    
    var wkOpt = __CLPK_doublereal(0.0)
    var lWork = __CLPK_integer(-1)
    var iWork = [__CLPK_integer](repeating: 0, count: Int(8 * min(M, N)))
    
    var error = __CLPK_integer(0)
    
    var s = Vector(repeating: 0.0, count: Int(min(M, N)))
    var U = Matrix(Int(LDU), Int(M))
    var VT = Matrix(Int(LDVT), Int(N))
    
    /* Query and allocate the optimal workspace */
    dgesdd_(&jobz, &M, &N, &_A.flat, &LDA, &s, &U.flat, &LDU, &VT.flat, &LDVT, &wkOpt, &lWork, &iWork, &error)
    
    lWork = __CLPK_integer(wkOpt)
    var work = Vector(repeating: 0.0, count: Int(lWork))
    
    /* Compute SVD */
    dgesdd_(&jobz, &M, &N, &_A.flat, &LDA, &s, &U.flat, &LDU, &VT.flat, &LDVT, &work, &lWork, &iWork, &error)
    
    precondition(error == 0, "Failed to compute SVD")
    
    return (transpose(U), diag(Int(M), Int(N), s), VT)
}
