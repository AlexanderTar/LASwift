// MatrixStatistics.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
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

// MARK: - Statistic functions on matrix

private func requireNonEmpty(_ A: Matrix, _ function: String) {
    precondition(A.rows > 0 && A.cols > 0, "\(function) requires a non-empty matrix")
}

/// Return vector of largest elements of matrix in a specified dimension.
///
/// A precondition error is thrown if the matrix is empty. See `max(_: Vector)` for `NaN` behaviour.
///
/// - Parameters
///     - A: matrix
///     - d: dimension (.Column or .Row, defaults to .Row)
public func max(_ A: Matrix, _ d: Dim = .Row) -> Vector {
    requireNonEmpty(A, "max")
    return aggMatrixFunction(vDSP_maxvD, A, d)
}

/// Return vector of indices of largest elements of matrix in a specified dimension.
///
/// A precondition error is thrown if the matrix is empty. `NaN` elements are skipped.
///
/// - Parameters
///     - A: matrix
///     - d: dimension (.Column or .Row, defaults to .Row)
public func maxi(_ A: Matrix, _ d: Dim = .Row) -> [Int] {
    requireNonEmpty(A, "maxi")
    return aggMatrixIFunction(vDSP_maxviD, A, d)
}

/// Return vector of smallest elements of matrix in a specified dimension.
///
/// A precondition error is thrown if the matrix is empty. See `max(_: Vector)` for `NaN` behaviour.
///
/// - Parameters
///     - A: matrix
///     - d: dimension (.Column or .Row, defaults to .Row)
public func min(_ A: Matrix, _ d: Dim = .Row) -> Vector {
    requireNonEmpty(A, "min")
    return aggMatrixFunction(vDSP_minvD, A, d)
}

/// Return vector of indices of smallest elements of matrix in a specified dimension.
///
/// A precondition error is thrown if the matrix is empty. `NaN` elements are skipped.
///
/// - Parameters
///     - A: matrix
///     - d: dimension (.Column or .Row, defaults to .Row)
public func mini(_ A: Matrix, _ d: Dim = .Row) -> [Int] {
    requireNonEmpty(A, "mini")
    return aggMatrixIFunction(vDSP_minviD, A, d)
}

/// Return vector of mean values of matrix in a specified dimension.
///
/// A precondition error is thrown if the matrix is empty.
///
/// - Parameters
///     - A: matrix
///     - d: dimension (.Column or .Row, defaults to .Row)
public func mean(_ A: Matrix, _ d: Dim = .Row) -> Vector {
    requireNonEmpty(A, "mean")
    return aggMatrixFunction(vDSP_meanvD, A, d)
}

/// Return vector of standard deviation values of matrix in a specified dimension.
///
/// By default these are sample standard deviations (divide by N - 1), like Matlab's `std`;
/// pass `normalization: .population` to divide by N.
///
/// A precondition error is thrown if the matrix is empty. See `std(_: Vector)` for input
/// holding `NaN` or an infinity.
///
/// - Parameters
///     - A: matrix
///     - d: dimension (.Column or .Row, defaults to .Row)
///     - normalization: `.sample` (N - 1, the default) or `.population` (N)
public func std(_ A: Matrix, _ d: Dim = .Row, normalization: Normalization = .sample) -> Vector {
    requireNonEmpty(A, "std")
    return aggMatrixFunction({ std($0, normalization: normalization) }, A, d)
}

/// Return normalized matrix (substract mean value and divide by standard deviation)
/// in specified dimension. The result has the shape of A.
///
/// The deviation is the population deviation (divides by N).
///
/// - Parameters
///     - A: matrix
///     - d: dimension (.Column or .Row, defaults to .Row)
/// - Returns: normalized matrix A
public func normalize(_ A: Matrix, _ d: Dim = .Row) -> Matrix {
    switch d {
    case .Row:
        return Matrix(A.map { normalize(Vector($0)) })
    case .Column:
        return transpose(Matrix(transpose(A).map { normalize(Vector($0)) }))
    }
}

/// Return vector of sums of values of matrix in a specified dimension.
///
/// - Parameters
///     - A: matrix
///     - d: dimension (.Column or .Row, defaults to .Row)
public func sum(_ A: Matrix, _ d: Dim = .Row) -> Vector {
    return aggMatrixFunction(vDSP_sveD, A, d)
}

/// Return vector of sums of squared values of matrix in a specified dimension.
///
/// - Parameters
///     - A: matrix
///     - d: dimension (.Column or .Row, defaults to .Row)
public func sumsq(_ A: Matrix, _ d: Dim = .Row) -> Vector {
    return aggMatrixFunction(vDSP_svesqD, A, d)
}
