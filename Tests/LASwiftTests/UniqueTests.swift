//
//  UniqueTests.swift
//  LASwift
//
//  Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
//  All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the BSD license. See the LICENSE file for details.
//

import LASwift
import Testing

// Reference values from NumPy's `numpy.unique` (with `axis=0` / `axis=1` for matrices).
@Suite("Unique")
struct UniqueTests {
    @Test("vector with duplicates is sorted and deduplicated")
    func vectorDuplicates() {
        #expect(unique([3.0, 1.0, 2.0, 3.0, 1.0, 1.0]) == [1.0, 2.0, 3.0])
    }

    @Test("already unique vector is sorted")
    func vectorAlreadyUnique() {
        #expect(unique([5.0, -1.0, 2.5]) == [-1.0, 2.5, 5.0])
    }

    @Test("single element vector")
    func vectorSingle() {
        #expect(unique([4.0]) == [4.0])
        #expect(unique([2.0, 2.0, 2.0]) == [2.0])
    }

    @Test("unique rows in lexicographic order")
    func matrixRows() {
        let A = Matrix([[3.0, 1.0], [1.0, 2.0], [3.0, 1.0], [1.0, 0.0]])
        #expect(unique(A, .Row) == Matrix([[1.0, 0.0], [1.0, 2.0], [3.0, 1.0]]))
    }

    @Test("unique columns in lexicographic order")
    func matrixColumns() {
        let A = Matrix([[3.0, 1.0, 3.0, 1.0],
                        [1.0, 2.0, 1.0, 0.0]])
        #expect(unique(A, .Column) == Matrix([[1.0, 1.0, 3.0],
                                              [0.0, 2.0, 1.0]]))
    }

    @Test("rows and columns differ on a non-symmetric matrix")
    func rowsVersusColumns() {
        let A = Matrix([[1.0, 1.0, 2.0],
                        [1.0, 1.0, 2.0]])
        #expect(unique(A, .Row) == Matrix([[1.0, 1.0, 2.0]]))
        #expect(unique(A, .Column) == Matrix([[1.0, 2.0],
                                              [1.0, 2.0]]))
    }

    @Test("already unique matrix keeps its size")
    func matrixAlreadyUnique() {
        let A = Matrix([[1.0, 2.0], [3.0, 4.0]])
        #expect(unique(A, .Row) == A)
        #expect(unique(A, .Column) == A)
    }

    @Test("single element matrix")
    func matrixSingle() {
        #expect(unique(Matrix([[7.0]]), .Row) == Matrix([[7.0]]))
        #expect(unique(Matrix([[7.0]]), .Column) == Matrix([[7.0]]))
    }
}
