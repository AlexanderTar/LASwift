// MatrixAlgebra.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

import Accelerate
import CLASwiftLAPACK

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
    var C: Matrix = zeros(A.cols, A.rows)
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
    var C: Matrix = zeros(A.rows, B.cols)
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
    var B = Matrix(A)
    
    var M = Int(A.rows)
    var N = M
    var LDA = N
    var pivot = [Int](repeating: 0, count: Int(N))
    
    var wkOpt = Double(0.0)
    var lWork = Int(-1)
    
    var error: Int = 0
    
    laswift_dgetrf(&M, &N, &(B.flat), &LDA, &pivot, &error)
    
    precondition(error == 0, "Matrix is non invertible")
    
    /* Query and allocate the optimal workspace */
    
    laswift_dgetri(&N, &(B.flat), &LDA, &pivot, &wkOpt, &lWork, &error)
    
    lWork = Int(wkOpt)
    var work = Vector(repeating: 0.0, count: Int(lWork))
    
    /* Compute inversed matrix */
    
    laswift_dgetri(&N, &(B.flat), &LDA, &pivot, &work, &lWork, &error)
    
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
    
    var V = Matrix(A)
    
    var N = Int(A.rows)
    
    var LDA = N
    
    var wkOpt = Double(0.0)
    var lWork = Int(-1)
    
    var jobvl: Int8 = 86 // 'V'
    var jobvr: Int8 = 86 // 'V'
    
    var error = Int(0)
    
    // Real parts of eigenvalues
    var wr = Vector(repeating: 0.0, count: Int(N))
    // Imaginary parts of eigenvalues
    var wi = Vector(repeating: 0.0, count: Int(N))
    // Left eigenvectors
    var vl = [Double](repeating: 0.0, count: Int(N * N))
    // Right eigenvectors
    var vr = [Double](repeating: 0.0, count: Int(N * N))
    
    var ldvl = N
    var ldvr = N
    
    /* Query and allocate the optimal workspace */
    
    laswift_dgeev(&jobvl, &jobvr, &N, &V.flat, &LDA, &wr, &wi, &vl, &ldvl, &vr, &ldvr, &wkOpt, &lWork, &error)
    
    lWork = Int(wkOpt)
    var work = Vector(repeating: 0.0, count: Int(lWork))
    
    /* Compute eigen vectors */
    
    laswift_dgeev(&jobvl, &jobvr, &N, &V.flat, &LDA, &wr, &wi, &vl, &ldvl, &vr, &ldvr, &work, &lWork, &error)
    
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
    var _A = toCols(A, .Row)
    
    var jobz: Int8 = 65 // 'A'
    
    var M = Int(A.rows);
    var N = Int(A.cols);
    
    var LDA = M;
    var LDU = M;
    var LDVT = N;
    
    var wkOpt = Double(0.0)
    var lWork = Int(-1)
    var iWork = [Int](repeating: 0, count: Int(8 * min(M, N)))
    
    var error = Int(0)
    
    var s = Vector(repeating: 0.0, count: Int(min(M, N)))
    var U = Matrix(Int(LDU), Int(M))
    var VT = Matrix(Int(LDVT), Int(N))
    
    /* Query and allocate the optimal workspace */
    laswift_dgesdd(&jobz, &M, &N, &_A.flat, &LDA, &s, &U.flat, &LDU, &VT.flat, &LDVT, &wkOpt, &lWork, &iWork, &error)
    
    lWork = Int(wkOpt)
    var work = Vector(repeating: 0.0, count: Int(lWork))
    
    /* Compute SVD */
    laswift_dgesdd(&jobz, &M, &N, &_A.flat, &LDA, &s, &U.flat, &LDU, &VT.flat, &LDVT, &work, &lWork, &iWork, &error)
    
    precondition(error == 0, "Failed to compute SVD")
    
    return (toRows(U, .Column), diag(Int(M), Int(N), s), VT)
}

/// Perform a generalized singular value decomposition of 2 given matrices.
///
/// With `A` of size m x n and `B` of size p x n, LAPACK's `dggsvd3` computes orthogonal
/// `U` (m x m), `V` (p x p) and `Q` (n x n) with `U' * A * Q = D1 * [0 R]` and
/// `V' * B * Q = D2 * [0 R]`, where `R` is upper triangular and `D1`, `D2` are
/// diagonal-like with the generalized singular values `alpha` and `beta`
/// (`alpha^2 + beta^2 = 1`). The factors are full size, not economy size.
///
/// Precondition: `A` and `B` need the same number of columns.
///
/// - Parameters:
///    - A: first matrix (m x n)
///    - B: second matrix (p x n)
/// - Returns: matrices U (m x m), V (p x p) and Q (n x n), vectors alpha and beta with one
///            entry per generalized singular value (`l` of them, in LAPACK's order; empty
///            when `l` is 0), and whether LAPACK converged. When `success` is `false` the
///            factors are not meaningful and alpha and beta are empty.
public func gsvd(_ A: Matrix, _ B: Matrix) -> (U: Matrix, V: Matrix, Q: Matrix, alpha: Vector, beta: Vector, success: Bool) {
    precondition(A.cols == B.cols, "Matrices must have the same number of columns")
    /* LAPACK is using column-major order */
    var _A = toCols(A, .Row)
    var _B = toCols(B, .Row)
    
    var jobu:Int8 = Int8(Array("U".utf8).first!)
    var jobv:Int8 = Int8(Array("V".utf8).first!)
    var jobq:Int8 = Int8(Array("Q".utf8).first!)
    
    var M = Int(A.rows)
    var N = Int(A.cols)
    var P = Int(B.rows)
    
    var LDA = M
    var LDB = P
    var LDU = M
    var LDV = P
    var LDQ = N
    
    var iWork = [Int](repeating: 0, count: N)
    var error = Int(0)
    
    var k = Int()
    var l = Int()
    
    var U = Matrix(Int(LDU), Int(M))
    var V = Matrix(Int(LDV), Int(P))
    var Q = Matrix(Int(LDQ), Int(N))
    var alpha = Vector(repeating: 0.0, count: N)
    var beta = Vector(repeating: 0.0, count: N)
    
    /* Query and allocate the optimal workspace */
    var wkOpt = 0.0
    var lWork = -1
    laswift_dggsvd3(&jobu, &jobv, &jobq, &M, &N, &P, &k, &l, &_A.flat, &LDA, &_B.flat, &LDB, &alpha, &beta, &U.flat, &LDU, &V.flat, &LDV, &Q.flat, &LDQ, &wkOpt, &lWork, &iWork, &error)
    precondition(error == 0, "Failed to query the GSVD workspace size")
    
    lWork = Int(wkOpt)
    var work = Vector(repeating: 0.0, count: lWork)
    
    /* Compute GSVD */
    laswift_dggsvd3(&jobu, &jobv, &jobq, &M, &N, &P, &k, &l, &_A.flat, &LDA, &_B.flat, &LDB, &alpha, &beta, &U.flat, &LDU, &V.flat, &LDV, &Q.flat, &LDQ, &work, &lWork, &iWork, &error)
    
    guard error == 0 else {
        return (toRows(U, .Column), toRows(V, .Column), toRows(Q, .Column), [], [], false)
    }
    return (toRows(U, .Column), toRows(V, .Column), toRows(Q, .Column), Vector(alpha[k..<(k + l)]), Vector(beta[k..<(k + l)]), true)
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
    
    var N = Int(A.rows)
    
    /* LAPACK is using column-major order */
    var U = toCols(A, .Row)
    
    var LDA = N
    
    var error = Int(0)
    
    /* Compute Cholesky decomposition */
    
    laswift_dpotrf(&uplo, &N, &U.flat, &LDA, &error)
    
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
    var res = zeros(A.rows, A.cols)
    let cols = A.cols
    A.flat.withUnsafeBufferPointer { src in
        res.flat.withUnsafeMutableBufferPointer { dst in
            for i in 0..<A.rows {
                // Upper keeps columns i..<cols (nothing once i >= cols), lower columns 0...i (at most cols).
                let first = t == .Upper ? i : 0
                let count = t == .Upper ? cols - i : min(i + 1, cols)
                if count > 0 {
                    vDSP_mmovD(src.baseAddress! + i * cols + first, dst.baseAddress! + i * cols + first,
                               vDSP_Length(count), 1, vDSP_Length(cols), vDSP_Length(cols))
                }
            }
        }
    }
    return res
}

/// Compute the determinant of a given square matrix.
///
///    A precondition error is thrown if the given matrix is singular or algorithm fails to converge.
///
/// - Parameters:
///     - A: square matrix=
/// - Returns: determinant of A matrix
public func det(_ A: Matrix) -> Double {
    precondition(A.rows == A.cols, "Matrix dimensions must agree")
    var B = Matrix(A)
    
    var M = Int(A.rows)
    var N = M
    var LDA = N
    var pivot = [Int](repeating: 0, count: Int(N))
    
    var error: Int = 0
    
    laswift_dgetrf(&M, &N, &(B.flat), &LDA, &pivot, &error)
    
    var d = 1.0

    for i in (0..<B.rows) {
        d *= B[i, i]
        if (pivot[i] != i + 1) {
            d *= -1
        }
    }
    
    return d
}

 /// Return the result of convolving the given matrix with the provided kernel.
 ///
 /// - Parameters:
 ///    - A: Matrix
 ///    - K: Matrix (Needs to be smaller in dimension than A)
 /// - Returns: Matrix result of the convolution
 @available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
 public func convolve(_ A: Matrix, _ K: Matrix) -> Matrix {
     precondition(A.rows > K.rows && A.cols > K.cols, "The kernel matrix needs to be smaller than the matrix it will convolve.")

     let result: [Double]

     if K.rows == 3 {
         result = Accelerate.vDSP.convolve(A.flat, rowCount: A.rows, columnCount: A.cols, with3x3Kernel: K.flat)
     } else {
         result = Accelerate.vDSP.convolve(A.flat, rowCount: A.rows, columnCount: A.cols, withKernel: K.flat, kernelRowCount: K.rows, kernelColumnCount: K.cols)
     }

     return Matrix(A.rows, A.cols, result)
 }
