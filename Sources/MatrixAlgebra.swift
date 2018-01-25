// MatrixAlgebra.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

import Accelerate

/// Matrix triangular part.
///
/// - Upper: Upper triangular part.
/// - Lower: Lower triangular part.
public enum Triangle {
    case Upper
    case Lower
}

// MARK: - Linear algebra operations on matrices

/// Compute the trace of a matrix.
///
/// - Parameters:
///     - A: matrix to compute trace of
/// - Returns: sum of the elements on the main diagonal
public func trace(_ A: Matrix) -> Double {
    precondition(A.rows == A.cols, "Matrix dimensions must agree")
    return sum((0..<A.rows).map { A[$0, $0] })
}

/// Transpose matrix.
///
/// Alternatively, `transpose(A)` can be executed with `A′`.
///
/// - Parameters
///     - A: matrix
/// - Returns: transposed matrix
public func transpose(_ A: Matrix) -> Matrix {
    let C: Matrix = zeros(A.cols, A.rows)
    vDSP_mtransD(A.flat, 1, &(C.flat), 1, vDSP_Length(A.cols), vDSP_Length(A.rows))
    return C
}

/// Transpose matrix.
///
/// Alternatively, `A′` can be executed with `transpose(A)`.
///
/// - Parameters
///     - A: matrix
/// - Returns: transposed matrix
public postfix func ′ (_ a: Matrix) -> Matrix {
    return transpose(a)
}

/// Perform matrix multiplication.
///
/// Alternatively, `mtimes(A, B)` can be executed with `A * B`.
///
/// - Parameters
///     - A: left matrix
///     - B: right matrix
/// - Returns: matrix product of A and B
public func mtimes(_ A: Matrix, _ B: Matrix) -> Matrix {
    precondition(A.cols == B.rows, "Matrix dimensions must agree")
    let C: Matrix = zeros(A.rows, B.cols)
    vDSP_mmulD(A.flat, 1, B.flat, 1, &(C.flat), 1, vDSP_Length(A.rows), vDSP_Length(B.cols), vDSP_Length(A.cols))
    return C
}

/// Perform matrix multiplication.
///
/// Alternatively, `A * B` can be executed with `mtimes(A, B)`.
///
/// - Parameters
///     - A: left matrix
///     - B: right matrix
/// - Returns: matrix product of A and B
public func * (_ A: Matrix, _ B: Matrix) -> Matrix {
    return mtimes(A, B)
}

/// Raise matrix to specified power (integer value).
///
/// If power is 1, source matrix is returned
/// If power is -1, inverted matrix is returned
/// If power is > 1, continuous matrix product result is returned (eg `mpower(A, 2) = mtimes(A, A)`)
/// If power is < -1, continuous matrix product of inverted matrix result is returned
/// All other values are invalid
///
/// Alternatively, `mpower(A, p)` can be executed with `A ^ p`.
///
/// - Parameters
///     - A: matrix
///     - p: power to raise matrix to (integer)
/// - Returns: matrix A raised to power p
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
        return eye(A.rows, A.cols)
    }
}

/// Raise matrix to specified power (integer value).
///
/// If power is 1, source matrix is returned
/// If power is -1, inverted matrix is returned
/// If power is > 1, continuous matrix product result is returned (eg `A ^ 2 = mtimes(A, A)`)
/// If power is < -1, continuous matrix product of inverted matrix result is returned
/// All other values are invalid
///
/// Alternatively, `A ^ p` can be executed with `mpower(A, p)`.
///
/// - Parameters
///     - A: matrix
///     - p: power to raise matrix to (integer)
/// - Returns: matrix A raised to power p
public func ^ (_ a: Matrix, _ p: Int) -> Matrix {
    return mpower(a, p)
}

/// Compute the inverse of a given square matrix.
///
///	A precondition error is thrown if the given matrix is singular or algorithm fails to converge.
///
/// - Parameters:
///     - A: square matrix to invert
/// - Returns: inverse of A matrix
public func inv(_ A: Matrix) -> Matrix {
    precondition(A.rows == A.cols, "Matrix dimensions must agree")
    let B = Matrix(A)
    
    var M = __CLPK_integer(A.rows)
    var N = M
    var LDA = N
    var pivot = [__CLPK_integer](repeating: 0, count: Int(N))
    
    var wkOpt = __CLPK_doublereal(0.0)
    var lWork = __CLPK_integer(-1)
    
    var error: __CLPK_integer = 0
    
    dgetrf_(&M, &N, &(B.flat), &LDA, &pivot, &error)
    
    precondition(error == 0, "Matrix is non invertible")
    
    /* Query and allocate the optimal workspace */
    
    dgetri_(&N, &(B.flat), &LDA, &pivot, &wkOpt, &lWork, &error)
    
    lWork = __CLPK_integer(wkOpt)
    var work = Vector(repeating: 0.0, count: Int(lWork))
    
    /* Compute inversed matrix */
    
    dgetri_(&N, &(B.flat), &LDA, &pivot, &work, &lWork, &error)
    
    precondition(error == 0, "Matrix is non invertible")
    
    return B
}

/// Compute eigen values and vectors of a given square matrix.
///
///	A precondition error is thrown if the algorithm fails to converge.
///
/// - Parameters:
///     - A: square matrix to calculate eigen values and vectors of
/// - Returns: eigenvectors matrix (by rows) and diagonal matrix with eigenvalues on the main diagonal
public func eig(_ A: Matrix) -> (V: Matrix, D: Matrix) {
    precondition(A.rows == A.cols, "Matrix dimensions must agree")
    
    let V = Matrix(A)
    
    var N = __CLPK_integer(A.rows)
    
    var LDA = N
    
    var wkOpt = __CLPK_doublereal(0.0)
    var lWork = __CLPK_integer(-1)
    
    var jobvl: Int8 = 86 // 'V'
    var jobvr: Int8 = 86 // 'V'
    
    var error = __CLPK_integer(0)
    
    // Real parts of eigenvalues
    var wr = Vector(repeating: 0.0, count: Int(N))
    // Imaginary parts of eigenvalues
    var wi = Vector(repeating: 0.0, count: Int(N))
    // Left eigenvectors
    var vl = [__CLPK_doublereal](repeating: 0.0, count: Int(N * N))
    // Right eigenvectors
    var vr = [__CLPK_doublereal](repeating: 0.0, count: Int(N * N))
    
    var ldvl = N
    var ldvr = N
    
    /* Query and allocate the optimal workspace */
    
    dgeev_(&jobvl, &jobvr, &N, &V.flat, &LDA, &wr, &wi, &vl, &ldvl, &vr, &ldvr, &wkOpt, &lWork, &error)
    
    lWork = __CLPK_integer(wkOpt)
    var work = Vector(repeating: 0.0, count: Int(lWork))
    
    /* Compute eigen vectors */
    
    dgeev_(&jobvl, &jobvr, &N, &V.flat, &LDA, &wr, &wi, &vl, &ldvl, &vr, &ldvr, &work, &lWork, &error)
    
    precondition(error == 0, "Failed to compute eigen vectors")
    
    return (toRows(Matrix(A.rows, A.cols, vl), .Column), diag(wr))
}

/// Perform a singular value decomposition of a given matrix.
///
/// - Parameters:
///    - A: matrix to find singular values of
/// - Returns: matrices U, S, and V such that `A = U * S * transpose(V)`
public func svd(_ A: Matrix) -> (U: Matrix, S: Matrix, V: Matrix) {
    /* LAPACK is using column-major order */
    let _A = toCols(A, .Row)
    
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
    let U = Matrix(Int(LDU), Int(M))
    let VT = Matrix(Int(LDVT), Int(N))
    
    /* Query and allocate the optimal workspace */
    dgesdd_(&jobz, &M, &N, &_A.flat, &LDA, &s, &U.flat, &LDU, &VT.flat, &LDVT, &wkOpt, &lWork, &iWork, &error)
    
    lWork = __CLPK_integer(wkOpt)
    var work = Vector(repeating: 0.0, count: Int(lWork))
    
    /* Compute SVD */
    dgesdd_(&jobz, &M, &N, &_A.flat, &LDA, &s, &U.flat, &LDU, &VT.flat, &LDVT, &work, &lWork, &iWork, &error)
    
    precondition(error == 0, "Failed to compute SVD")
    
    return (toRows(U, .Column), diag(Int(M), Int(N), s), VT)
}

/// Compute the Cholesky factorization of a real symmetric positive definite matrix.
///
///	A precondition error is thrown if the algorithm fails to converge.
///
/// - Parameters:
///     - A: square matrix to compute Cholesky factorization of
///     - t: Triangle value (.Upper, .Lower)
/// - Returns: upper triangular matrix U so that `A = U' * U` or 
///            lower triangular matrix L so that `A = L * L'`
public func chol(_ A: Matrix, _ t: Triangle = .Upper) -> Matrix {
    precondition(A.rows == A.cols, "Matrix dimensions must agree")
    
    var uplo: Int8
    switch t {
    case .Upper:
        uplo = 85 // 'U'
    case .Lower:
        uplo = 76 // 'L'
    }
    
    var N = __CLPK_integer(A.rows)
    
    /* LAPACK is using column-major order */
    var U = toCols(A, .Row)
    
    var LDA = N
    
    var error = __CLPK_integer(0)
    
    /* Compute Cholesky decomposition */
    
    dpotrf_(&uplo, &N, &U.flat, &LDA, &error)
    
    precondition(error == 0, "Failed to compute Cholesky decomposition")
    
    U = toRows(U, .Column)
    
    return tri(U, t)
}

/// Return the upper/lower triangular part of a given matrix.
///
/// - Parameters:
///     - A: matrix
///     - t: Triangle value (.Upper, .Lower)
/// - Returns: upper/lower triangular part
public func tri(_ A: Matrix, _ t: Triangle) -> Matrix {
    let _A = zeros(A.rows, A.cols)
    switch t {
    case .Upper:
        for i in (0..<A.rows) {
            A.flat.withUnsafeBufferPointer { bufPtr in
                let p = bufPtr.baseAddress! + (i * _A.cols) + i
                vDSP_mmovD(p, &_A.flat[(i * _A.cols) + i], vDSP_Length(A.cols - i), vDSP_Length(1), vDSP_Length(A.cols), vDSP_Length(_A.cols))
            }
        }
    case .Lower:
        for i in (0..<A.rows) {
            A.flat.withUnsafeBufferPointer { bufPtr in
                let p = bufPtr.baseAddress! + (i * _A.cols)
                vDSP_mmovD(p, &_A.flat[(i * _A.cols)], vDSP_Length(i + 1), vDSP_Length(1), vDSP_Length(A.cols), vDSP_Length(_A.cols))
            }
        }
    }
    return _A
}
