// MatrixStatistics.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

// MARK: - Statistic functions on matrix

public func max(_ A: Matrix) -> Vector {
    return aggMatrixFunction(max, A)
}

public func min(_ A: Matrix) -> Vector {
    return aggMatrixFunction(min, A)
}

public func mean(_ A: Matrix) -> Vector {
    return aggMatrixFunction(mean, A)
}

public func std(_ A: Matrix) -> Vector {
    return aggMatrixFunction(std, A)
}

public func norm(_ A: Matrix) -> Matrix {
    var B = zeros(A.rows, A.cols)
    for c in (0..<A.cols) {
        B[col:c] = norm(A[col:c])
    }
    return B
}
