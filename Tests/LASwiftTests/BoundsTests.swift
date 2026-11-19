//
//  BoundsTests.swift
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

// Regression tests for memory-safety and bounds bugs found in the TASK-1872 audit.
// Each test pins the correct result (or, in an exit test, the LASwift precondition message).

@Suite("tri on non-square matrices")
struct TriangleBoundsTests {
    let tall = Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0], [7.0, 8.0]])
    let wide = Matrix([[1.0, 2.0, 3.0, 4.0], [5.0, 6.0, 7.0, 8.0]])

    @Test("lower triangle of a tall matrix")
    func lowerTall() {
        expectClose(tri(tall, .Lower), Matrix([[1.0, 0.0], [3.0, 4.0], [5.0, 6.0], [7.0, 8.0]]))
    }

    @Test("upper triangle of a tall matrix")
    func upperTall() {
        expectClose(tri(tall, .Upper), Matrix([[1.0, 2.0], [0.0, 4.0], [0.0, 0.0], [0.0, 0.0]]))
    }

    @Test("lower triangle of a wide matrix")
    func lowerWide() {
        expectClose(tri(wide, .Lower), Matrix([[1.0, 0.0, 0.0, 0.0], [5.0, 6.0, 0.0, 0.0]]))
    }

    @Test("upper triangle of a wide matrix")
    func upperWide() {
        expectClose(tri(wide, .Upper), Matrix([[1.0, 2.0, 3.0, 4.0], [0.0, 6.0, 7.0, 8.0]]))
    }
}

@Suite("gsvd")
struct GSVDBoundsTests {
    @Test("two zero matrices have no generalized singular values")
    func zeroMatrices() {
        let r = gsvd(zeros(2, 2), zeros(2, 2))
        #expect(r.success)
        #expect(r.alpha.isEmpty)
        #expect(r.beta.isEmpty)
    }

    // Shapes follow LAPACK's dggsvd3 (full size): U is m x m, V is p x p, Q is n x n.
    @Test("returns full-size orthogonal U, V and Q that decompose A and B")
    func decomposition() {
        let a = Matrix([[1.0, 6.0, 11.0], [2.0, 7.0, 12.0], [3.0, 8.0, 13.0], [4.0, 9.0, 14.0], [5.0, 10.0, 15.0]])
        let b = Matrix([[8.0, 1.0, 6.0], [3.0, 5.0, 7.0], [4.0, 9.0, 2.0]])
        let r = gsvd(a, b)
        #expect(r.success)
        #expect((r.U.rows, r.U.cols) == (5, 5))
        #expect((r.V.rows, r.V.cols) == (3, 3))
        #expect((r.Q.rows, r.Q.cols) == (3, 3))
        expectClose(r.U′ * r.U, eye(5, 5), tol: 1e-12)
        expectClose(r.V′ * r.V, eye(3, 3), tol: 1e-12)
        expectClose(r.Q′ * r.Q, eye(3, 3), tol: 1e-12)
        // B has full rank, so k = 0 and l = 3: alpha, beta have one entry per column.
        #expect(r.alpha.count == 3)
        #expect(r.beta.count == 3)
        for (x, y) in zip(r.alpha, r.beta) { expectClose(x * x + y * y, 1.0, tol: 1e-12) }
        // U'AQ = D1 R and V'BQ = D2 R with the same upper triangular R, and rows of U'AQ
        // below the first l rows are zero. A has rank 2 here, so one alpha is 0: compare
        // alpha * (V'BQ) with beta * (U'AQ) instead of dividing.
        let ua = r.U′ * a * r.Q
        let vb = r.V′ * b * r.Q
        for i in 0..<3 {
            for j in 0..<3 {
                expectClose(ua[i, j] * r.beta[i], vb[i, j] * r.alpha[i], tol: 1e-10)
            }
        }
        for i in 3..<5 { for j in 0..<3 { expectClose(ua[i, j], 0.0, tol: 1e-10) } }
    }
}

#if os(macOS) || os(Linux)
@Suite("gsvd preconditions")
struct GSVDPreconditionTests {
    @Test("matrices with different column counts fail the precondition")
    func columnMismatch() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = gsvd(zeros(3, 4), zeros(2, 2))
        }
        expectStderr(result, contains: "Matrices must have the same number of columns")
    }
}
#endif
