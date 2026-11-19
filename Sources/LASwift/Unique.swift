//
//  Unique.swift
//  LASwift
//
//  Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
//  All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the BSD license. See the LICENSE file for details.
//

/// Find the sorted unique values of a vector.
///
/// Values are compared exactly, so values that differ in the last bit are distinct.
///
/// - Parameters:
///    - a: vector to find unique values of
/// - Returns: new vector with the unique values of `a` in ascending order
public func unique(_ a: Vector) -> Vector {
    var result = Vector()
    for x in a.sorted() where result.last != x {
        result.append(x)
    }
    return result
}

/// Find the unique rows or columns of a matrix.
///
/// Rows (or columns) are compared exactly and the result is in lexicographic order:
/// by the first element, then by the second element, and so on.
///
/// - Parameters:
///    - A: matrix to find unique rows or columns of
///    - d: `.Row` to find unique rows, `.Column` to find unique columns
/// - Returns: new matrix with the unique rows (or columns) of `A` in lexicographic order
public func unique(_ A: Matrix, _ d: Dim) -> Matrix {
    let lines: [Vector]
    switch d {
    case .Row:
        lines = (0..<A.rows).map { A[row: $0] }
    case .Column:
        lines = (0..<A.cols).map { A[col: $0] }
    }
    var result = [Vector]()
    for line in lines.sorted(by: { $0.lexicographicallyPrecedes($1) }) where result.last != line {
        result.append(line)
    }
    switch d {
    case .Row:
        return Matrix(result)
    case .Column:
        return transpose(Matrix(result))
    }
}
