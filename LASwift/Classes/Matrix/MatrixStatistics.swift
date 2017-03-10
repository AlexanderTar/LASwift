// MatrixStatistics.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

// MARK: - Statistic functions on matrix

public func maxr(_ A: Matrix) -> Vector {
    return aggMatrixFunction(max, A)
}

public func maxc(_ A: Matrix) -> Vector {
    return aggMatrixFunction(max, transpose(A))
}

public func minr(_ A: Matrix) -> Vector {
    return aggMatrixFunction(min, A)
}

public func minc(_ A: Matrix) -> Vector {
    return aggMatrixFunction(min, transpose(A))
}

public func meanr(_ A: Matrix) -> Vector {
    return aggMatrixFunction(mean, A)
}

public func meanc(_ A: Matrix) -> Vector {
    return aggMatrixFunction(mean, transpose(A))
}

public func stdr(_ A: Matrix) -> Vector {
    return aggMatrixFunction(std, A)
}

public func stdc(_ A: Matrix) -> Vector {
    return aggMatrixFunction(std, transpose(A))
}

public func normalizer(_ A: Matrix) -> Matrix {
    return Matrix(A.map { normalize(Vector($0)) })
}

public func normalizec(_ A: Matrix) -> Matrix {
    return Matrix(transpose(A).map { normalize(Vector($0)) })
}

public func sumr(_ A: Matrix) -> Vector {
    return aggMatrixFunction(sum, A)
}

public func sumc(_ A: Matrix) -> Vector {
    return aggMatrixFunction(sum, transpose(A))
}

public func sumsqr(_ A: Matrix) -> Vector {
    return aggMatrixFunction(sumsq, A)
}

public func sumsqc(_ A: Matrix) -> Vector {
    return aggMatrixFunction(sumsq, transpose(A))
}
