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

@Suite("slice extractor bounds")
struct SliceBoundsTests {
    // 2 rows, 3 columns.
    let m = Matrix([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])

    @Test("Take of every row or column returns the whole matrix")
    func takeAll() {
        expectClose(slice(m, (.Take(2), .All)), m)
        expectClose(slice(m, (.All, .Take(3))), m)
    }

    @Test("DropLast(0) and TakeLast of everything return the whole matrix")
    func dropLastNothing() {
        expectClose(slice(m, (.DropLast(0), .All)), m)
        expectClose(slice(m, (.All, .DropLast(0))), m)
        expectClose(slice(m, (.TakeLast(2), .TakeLast(3))), m)
    }

    @Test("Drop(0) returns the whole matrix")
    func dropNothing() {
        expectClose(slice(m, (.Drop(0), .Drop(0))), m)
    }
}

@Suite("range subscripts on non-square matrices")
struct RangeSubscriptShapeTests {
    let wide = Matrix([[1.0, 2.0, 3.0, 4.0], [5.0, 6.0, 7.0, 8.0]])
    let tall = Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0], [7.0, 8.0]])

    @Test("column range on a wide matrix")
    func columnsOfWide() {
        expectClose(wide[..., 1...], Matrix([[2.0, 3.0, 4.0], [6.0, 7.0, 8.0]]))
        expectClose(wide[0..<2, 1..<3], Matrix([[2.0, 3.0], [6.0, 7.0]]))
        expectClose(wide[..., ...3], Matrix([[1.0, 2.0, 3.0, 4.0], [5.0, 6.0, 7.0, 8.0]]))
    }

    @Test("row range on a tall matrix")
    func rowsOfTall() {
        expectClose(tall[1..., ...], Matrix([[3.0, 4.0], [5.0, 6.0], [7.0, 8.0]]))
        expectClose(tall[...2, ...], Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]]))
    }

    @Test("row range on a wide matrix")
    func rowsOfWide() {
        expectClose(wide[1..., ...], Matrix([[5.0, 6.0, 7.0, 8.0]]))
    }

    @Test("column range on a tall matrix")
    func columnsOfTall() {
        expectClose(tall[..., 1...], Matrix([[2.0], [4.0], [6.0], [8.0]]))
    }

    @Test("both ranges bounded on non-square matrices")
    func bothRanges() {
        expectClose(tall[1..., 0...], Matrix([[3.0, 4.0], [5.0, 6.0], [7.0, 8.0]]))
        expectClose(wide[1..., 2...], Matrix([[7.0, 8.0]]))
    }

    @Test("writing through range subscripts on non-square matrices")
    func writing() {
        var t = tall
        t[1..., ...] = Matrix([[0.0, 0.0], [0.0, 0.0], [0.0, 0.0]])
        expectClose(t, Matrix([[1.0, 2.0], [0.0, 0.0], [0.0, 0.0], [0.0, 0.0]]))
        var w = wide
        w[..., 1...] = Matrix([[0.0, 0.0, 0.0], [0.0, 0.0, 0.0]])
        expectClose(w, Matrix([[1.0, 0.0, 0.0, 0.0], [5.0, 0.0, 0.0, 0.0]]))
    }
}

#if os(macOS) || os(Linux)
@Suite("range subscript preconditions")
struct RangeSubscriptPreconditionTests {
    @Test("an empty row range fails the precondition")
    func emptyRows() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = Matrix([[1.0, 2.0], [3.0, 4.0]])[0..<0, ...]
        }
        expectStderr(result, contains: "Range must not be empty")
    }

    @Test("an empty column range fails the precondition")
    func emptyColumns() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = Matrix([[1.0, 2.0], [3.0, 4.0]])[..., 1..<1]
        }
        expectStderr(result, contains: "Range must not be empty")
    }

    @Test("an empty range fails the precondition when writing")
    func emptyWrite() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            var m = Matrix([[1.0, 2.0], [3.0, 4.0]])
            m[0..<0, 0..<2] = Matrix([[1.0, 2.0]])
        }
        expectStderr(result, contains: "Range must not be empty")
    }

    @Test("a range past the last column fails the precondition")
    func pastEnd() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = Matrix([[1.0, 2.0], [3.0, 4.0]])[0..<2, 0..<3]
        }
        expectStderr(result, contains: "Invalid range")
    }
}

#endif

#if os(macOS) || os(Linux)
@Suite("slice preconditions")
struct SlicePreconditionTests {
    @Test("a row position equal to the row count fails the precondition")
    func rowPositionAtCount() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = slice(Matrix([[1.0, 2.0], [3.0, 4.0]]), (.Pos([2]), .All))
        }
        expectStderr(result, contains: "Range out of bounds")
    }

    @Test("a column position equal to the column count fails the precondition")
    func columnPositionAtCount() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = slice(Matrix([[1.0, 2.0], [3.0, 4.0]]), (.All, .Pos([2])))
        }
        expectStderr(result, contains: "Range out of bounds")
    }

    @Test("a cyclic position never leaves the matrix")
    func cyclicPosition() {
        expectClose(slice(Matrix([[1.0, 2.0], [3.0, 4.0]]), (.PosCyc([2]), .PosCyc([-1]))), Matrix([[2.0]]))
    }

    @Test("a range with step 0 fails the precondition")
    func rangeStepZero() async {
        let rows = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = slice(Matrix([[1.0, 2.0], [3.0, 4.0]]), (.Range(0, 0, 1), .All))
        }
        expectStderr(rows, contains: "Range step must not be zero")
        let cols = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = slice(Matrix([[1.0, 2.0], [3.0, 4.0]]), (.All, .Range(0, 0, 1)))
        }
        expectStderr(cols, contains: "Range step must not be zero")
    }
}

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
