//
//  RankTests.swift
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

// Reference values from NumPy's `numpy.linalg.matrix_rank`.
@Suite("Matrix rank")
struct RankTests {
    @Test("full-rank square matrix")
    func fullRank() {
        #expect(rank(Matrix([[1.0, 2.0], [3.0, 4.0]])) == 2)
        #expect(rank(eye(4, 4)) == 4)
    }

    @Test("collinear rows")
    func collinearRows() {
        #expect(rank(Matrix([[1.0, 2.0, 3.0], [2.0, 4.0, 6.0], [1.0, 1.0, 1.0]])) == 2)
        #expect(rank(Matrix([[1.0, 2.0, 3.0, 4.0], [2.0, 4.0, 6.0, 8.0]])) == 1)
    }

    @Test("singular matrix with rounding noise")
    func singularWithNoise() {
        #expect(rank(Matrix([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]])) == 2)
    }

    @Test("zero matrix has rank 0")
    func zeroMatrix() {
        #expect(rank(zeros(3, 3)) == 0)
    }

    @Test("non-square matrices")
    func nonSquare() {
        #expect(rank(Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])) == 2)
        #expect(rank(Matrix([[1.0], [1.0], [1.0], [1.0]])) == 1)
    }

    @Test("tolerance override")
    func tolerance() {
        let A = Matrix([[1.0, 0.0], [0.0, 1e-8]])
        #expect(rank(A) == 2)
        #expect(rank(A, tol: 1e-6) == 1)
        #expect(rank(Matrix([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]), tol: 1e-20) == 3)
    }
}
