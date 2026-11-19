//
//  PowerOperatorTests.swift
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

@Suite("Power operators")
struct PowerOperatorTests {
    let a: Vector = [1.0, 2.0, 3.0]
    let A = Matrix([[1.0, 1.0], [1.0, 0.0]])

    @Test("`.**` binds tighter than `.*`")
    func elementwisePowerBeforeTimes() {
        expectClose(2 .* a .** 2, [2.0, 8.0, 18.0])
    }

    @Test("`.**` binds tighter than `+`")
    func elementwisePowerBeforePlus() {
        expectClose(a + a .** 2, [2.0, 6.0, 12.0])
    }

    @Test("`**` binds tighter than `.*`")
    func matrixPowerBeforeTimes() {
        expectClose(2 .* A ** 2, Matrix([[4.0, 2.0], [2.0, 2.0]]))
    }

    @Test("`**` binds tighter than `+`")
    func matrixPowerBeforePlus() {
        expectClose(A + A ** 2, Matrix([[3.0, 2.0], [2.0, 1.0]]))
    }

    @Test("`.**` on a vector and on a matrix")
    func elementwisePower() {
        expectClose(a .** 3.0, [1.0, 8.0, 27.0])
        expectClose(Matrix([[1.0, 2.0], [3.0, 4.0]]) .** 2.0, Matrix([[1.0, 4.0], [9.0, 16.0]]))
    }

    @Test("`**` is the matrix power")
    func matrixPower() {
        expectClose(A ** 1, A)
        expectClose(A ** 0, eye(2, 2))
        expectClose(A ** -1, Matrix([[0.0, 1.0], [1.0, -1.0]]))
        expectClose(A ** -2, inv(A) * inv(A))
    }

    @Test("matrix power by squaring matches repeated products")
    func matrixPowerLarge() {
        // Fibonacci: A^n = [[F(n+1), F(n)], [F(n), F(n-1)]].
        expectClose(A ** 20, Matrix([[10946.0, 6765.0], [6765.0, 4181.0]]))
        let B = Matrix([[2.0, 1.0, 0.0], [0.0, 1.0, 3.0], [1.0, 0.0, 1.0]])
        var product = B
        for _ in 2...7 { product = product * B }
        expectClose(B ** 7, product, tol: 1e-9)
        expectClose(mpower(B, 7), product, tol: 1e-9)
    }

    // The deprecated spellings keep working. The test is itself deprecated so the
    // zero-warning build holds.
    @available(*, deprecated)
    @Test("deprecated `^` and `.^` still compute powers")
    func deprecatedSpellings() {
        expectClose(a .^ 3.0, [1.0, 8.0, 27.0])
        expectClose(Matrix([[1.0, 2.0], [3.0, 4.0]]) .^ 2.0, Matrix([[1.0, 4.0], [9.0, 16.0]]))
        expectClose(A ^ 2, Matrix([[2.0, 1.0], [1.0, 1.0]]))
    }
}
