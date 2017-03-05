//
//  Algebraic.swift
//  Pods
//
//  Created by Alexander Taraymovich on 04/03/2017.
//
//

import Accelerate

// MARK: - Linear algebra operations on matrices

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

public func ^^^ (_ a: Matrix, _ p: Int) -> Matrix {
    return mpower(a, p)
}

public func inv(_ A: Matrix) -> Matrix {
    precondition(A.rows == A.cols, "Matrix dimensions must agree")
    var B = Matrix(A)
    
    var N = __CLPK_integer(A.rows)
    var pivot = [__CLPK_integer](repeating: 0, count: Int(N))
    var work = Vector(repeating: 0.0, count: Int(N))
    var lWork = N
    var error: __CLPK_integer = 0
    
    dgetrf_(&N, &N, &(B.flat), &N, &pivot, &error)
    
    assert(error == 0, "Matrix is non invertible")
    
    dgetri_(&N, &(B.flat), &N, &pivot, &work, &lWork, &error)
    
    assert(error == 0, "Matrix is non invertible")
    
    return B
}

public func eig(_ A: Matrix) -> (Matrix, Matrix) {
    precondition(A.rows == A.cols, "Matrix dimensions must agree")
    
    var V = Matrix(A)
    
    var N = __CLPK_integer(A.rows)
    var LDA = N
    var lWork = __CLPK_integer(1 + 6 * N + 2 * N * N)
    var work = Vector(repeating: 0.0, count: Int(lWork))
    var liWork = __CLPK_integer(3 + 5 * N)
    var iWork = [__CLPK_integer](repeating: 0, count: Int(liWork))
    var jobz: Int8 = 86 // 'V'
    var uplo: Int8 = 85 // 'U'
    var error: __CLPK_integer = 0
    
    var eig = Vector(repeating: 0.0, count: Int(N))
    
    dsyevd_(&jobz, &uplo, &N, &V.flat, &LDA, &eig, &work, &lWork, &iWork, &liWork, &error)
    
    assert(error == 0, "Failed to find eigen vectors")
    
    let D: Matrix = diag(Matrix(eig))
    
    return (transpose(V), D)
}
