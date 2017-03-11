// MatrixStatistics.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

// MARK: - Statistic functions on matrix

public func max(_ A: Matrix, _ d: Dim = .Row) -> Vector {
    return aggMatrixFunction(max, A, d)
}

public func min(_ A: Matrix, _ d: Dim = .Row) -> Vector {
    return aggMatrixFunction(min, A, d)
}

public func mean(_ A: Matrix, _ d: Dim = .Row) -> Vector {
    return aggMatrixFunction(mean, A, d)
}

public func std(_ A: Matrix, _ d: Dim = .Row) -> Vector {
    return aggMatrixFunction(std, A, d)
}

public func normalize(_ A: Matrix, _ d: Dim = .Row) -> Matrix {
    switch d {
    case .Row:
        return Matrix(A.map { normalize(Vector($0)) })
    case .Column:
        return Matrix(transpose(A).map { normalize(Vector($0)) })
    }
}

public func sum(_ A: Matrix, _ d: Dim = .Row) -> Vector {
    return aggMatrixFunction(sum, A, d)
}

public func sumsq(_ A: Matrix, _ d: Dim = .Row) -> Vector {
    return aggMatrixFunction(sumsq, A, d)
}
