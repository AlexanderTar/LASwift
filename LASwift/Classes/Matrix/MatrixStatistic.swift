//
//  Statistic.swift
//  Pods
//
//  Created by Alexander Taraymovich on 04/03/2017.
//
//

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
