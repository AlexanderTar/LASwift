//
//  EigTests.swift
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

@Suite("Eigen decomposition")
struct EigTests {
    /// Diagonal entry `m[i, i]` (the subscript is ambiguous with the slicing one).
    func d(_ m: Matrix, _ i: Int) -> Double { m.flat[i * m.cols + i] }

    /// Checks `A * (V + iVi) == (V + iVi) * (D + iDi)` through real and imaginary parts.
    func expectEigenpairs(_ A: Matrix, tol: Double = 1e-12, sourceLocation: SourceLocation = #_sourceLocation) {
        let e = eig(A)
        // (V + iVi)(D + iDi) = (V D - Vi Di) + i (V Di + Vi D)
        expectClose(A * e.V, e.V * e.D - e.Vi * e.Di, tol: tol, sourceLocation: sourceLocation)
        expectClose(A * e.Vi, e.V * e.Di + e.Vi * e.D, tol: tol, sourceLocation: sourceLocation)
    }

    @Test("real non-symmetric matrix with a real spectrum")
    func realNonSymmetric() {
        let A = Matrix([[0, 1], [-2, -3]])
        let e = eig(A)
        expectClose(A * e.V, e.V * e.D)
        expectClose(e.Vi, zeros(2, 2))
        expectClose(e.Di, zeros(2, 2))
        expectClose(e.D, Matrix([[-1.0, 0.0], [0.0, -2.0]]))
        expectEigenpairs(A)
    }

    @Test("symmetric matrix")
    func symmetric() {
        let A = Matrix([[2.0, 1.0, 0.0], [1.0, 3.0, 1.0], [0.0, 1.0, 4.0]])
        let e = eig(A)
        expectClose(A * e.V, e.V * e.D)
        expectClose(e.Vi, zeros(3, 3))
        expectClose(e.Di, zeros(3, 3))
        // Eigenvectors of a symmetric matrix are orthonormal.
        expectClose(e.V′ * e.V, eye(3, 3))
    }

    @Test("eigenvectors are columns of V")
    func columnsOfV() {
        let A = Matrix([[2.0, 0.0], [1.0, 3.0]])
        let e = eig(A)
        for j in 0..<2 {
            let v = e.V[col: j]
            let lambda = d(e.D, j)
            expectClose((A * Matrix(v)).flat, v.map { $0 * lambda })
        }
    }

    @Test("rotation has eigenvalues +i and -i")
    func rotation() {
        let A = Matrix([[0.0, -1.0], [1.0, 0.0]])
        let e = eig(A)
        expectClose(e.D, zeros(2, 2))
        expectClose([d(e.Di, 0), d(e.Di, 1)].sorted(), [-1.0, 1.0])
        expectClose(d(e.Di, 0), -d(e.Di, 1))
        expectEigenpairs(A)
    }

    @Test("3x3 matrix with one complex pair")
    func complexPair() {
        // Eigenvalues 2 and 1 ± 2i.
        let A = Matrix([[2.0, 0.0, 0.0], [0.0, 1.0, -2.0], [0.0, 2.0, 1.0]])
        let e = eig(A)
        let re = (0..<3).map { d(e.D, $0) }.sorted()
        let im = (0..<3).map { d(e.Di, $0) }.sorted()
        expectClose(re, [1.0, 1.0, 2.0])
        expectClose(im, [-2.0, 0.0, 2.0])
        expectEigenpairs(A)
        // The conjugate pair is stored as conjugate eigenvectors.
        let pair = (0..<3).filter { d(e.Di, $0) != 0.0 }
        #expect(pair.count == 2)
        guard pair.count == 2 else { return }
        let (j, k) = (pair[0], pair[1])
        expectClose(e.V[col: j], e.V[col: k])
        expectClose(e.Vi[col: j], e.Vi[col: k].map { -$0 })
    }

    @Test("eigenvectors have unit 2-norm")
    func normalisation() {
        let A = Matrix([[0.0, -1.0, 3.0], [1.0, 0.0, 2.0], [5.0, 1.0, 1.0]])
        let e = eig(A)
        for j in 0..<3 {
            let n = e.V[col: j].map { $0 * $0 }.reduce(0, +) + e.Vi[col: j].map { $0 * $0 }.reduce(0, +)
            expectClose(n, 1.0, tol: 1e-12)
        }
    }

    @Test("eigvals returns real and imaginary parts")
    func eigenvalues() {
        let A = Matrix([[2.0, 0.0, 0.0], [0.0, 1.0, -2.0], [0.0, 2.0, 1.0]])
        let ev = eigvals(A)
        let e = eig(A)
        expectClose(ev.re, (0..<3).map { d(e.D, $0) })
        expectClose(ev.im, (0..<3).map { d(e.Di, $0) })
    }
}
