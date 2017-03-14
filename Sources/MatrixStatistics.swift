// MatrixStatistics.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

// MARK: - Statistic functions on matrix

/// Return vector of largest elements of matrix in a specified dimension.
///
/// - Parameters
///     - A: matrix
///     - d: dimension (.Column or .Row, defaults to .Row)
public func max(_ A: Matrix, _ d: Dim = .Row) -> Vector {
    return aggMatrixFunction(max, A, d)
}

/// Return vector of indices of largest elements of matrix in a specified dimension.
///
/// - Parameters
///     - A: matrix
///     - d: dimension (.Column or .Row, defaults to .Row)
public func maxi(_ A: Matrix, _ d: Dim = .Row) -> [Int] {
    return aggMatrixIFunction(maxi, A, d)
}

/// Return vector of smallest elements of matrix in a specified dimension.
///
/// - Parameters
///     - A: matrix
///     - d: dimension (.Column or .Row, defaults to .Row)
public func min(_ A: Matrix, _ d: Dim = .Row) -> Vector {
    return aggMatrixFunction(min, A, d)
}

/// Return vector of indices of smallest elements of matrix in a specified dimension.
///
/// - Parameters
///     - A: matrix
///     - d: dimension (.Column or .Row, defaults to .Row)
public func mini(_ A: Matrix, _ d: Dim = .Row) -> [Int] {
    return aggMatrixIFunction(mini, A, d)
}

/// Return vector of mean values of matrix in a specified dimension.
///
/// - Parameters
///     - A: matrix
///     - d: dimension (.Column or .Row, defaults to .Row)
public func mean(_ A: Matrix, _ d: Dim = .Row) -> Vector {
    return aggMatrixFunction(mean, A, d)
}

/// Return vector of standard deviation values of matrix in a specified dimension.
///
/// - Parameters
///     - A: matrix
///     - d: dimension (.Column or .Row, defaults to .Row)
public func std(_ A: Matrix, _ d: Dim = .Row) -> Vector {
    return aggMatrixFunction(std, A, d)
}

/// Return normalized matrix (substract mean value and divide by standard deviation)
/// in dpecified dimension.
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
        return Matrix(transpose(A).map { normalize(Vector($0)) })
    }
}

/// Return vector of sums of values of matrix in a specified dimension.
///
/// - Parameters
///     - A: matrix
///     - d: dimension (.Column or .Row, defaults to .Row)
public func sum(_ A: Matrix, _ d: Dim = .Row) -> Vector {
    return aggMatrixFunction(sum, A, d)
}

/// Return vector of sums of squared values of matrix in a specified dimension.
///
/// - Parameters
///     - A: matrix
///     - d: dimension (.Column or .Row, defaults to .Row)
public func sumsq(_ A: Matrix, _ d: Dim = .Row) -> Vector {
    return aggMatrixFunction(sumsq, A, d)
}
