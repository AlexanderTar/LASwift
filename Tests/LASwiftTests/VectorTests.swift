//
//  VectorTests.swift
//  LASwift
//
//  Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
//  All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the BSD license. See the LICENSE file for details.
//

import Darwin
import LASwift
import Testing

@Suite("Vector construction")
struct VectorConstructionTests {
    let vec1 = ones(10)
    let vec2 = zeros(10)

    @Test("ones vector has correct size")
    func onesSize() {
        #expect(vec1.count == 10)
    }

    @Test("ones vector all ones")
    func onesAllOnes() {
        #expect(vec1.allSatisfy { $0 == 1.0 })
    }

    @Test("zeros vector has correct size")
    func zerosSize() {
        #expect(vec2.count == 10)
    }

    @Test("zeros vector all zeros")
    func zerosAllZeros() {
        #expect(vec2.allSatisfy { $0 == 0.0 })
    }

    @Test("zeros vectors are equal")
    func zerosEqual() {
        expectClose(zeros(10), vec2)
    }

    @Test("zeros and ones vectors are not equal")
    func zerosOnesNotEqual() {
        #expect(!isClose(vec2, vec1))
    }

    @Test("differently constructed ones vectors are equal")
    func onesConstructedDifferently() {
        expectClose(vec1, [Double](repeating: 1.0, count: 10))
    }
}

// These specs exercise the library's own tolerance-based comparison operators on
// vectors, so they use the operators directly. They go away with the operators.
@Suite("Vector comparison")
struct VectorComparisonTests {
    @Test("equal")
    func equal() {
        let v1 = [1.0, 2.0]
        let v2 = [1.0, 2.0]
        #expect(v1 == v2)
    }

    @Test("not equal")
    func notEqual() {
        let v1 = [1.0, 2.0]
        let v2 = [1.0, 4.0]
        #expect(v1 != v2)
    }

    @Test("greater/less than")
    func greaterLess() {
        let v1 = [11.0, 12.0]
        let v2 = [1.0, 2.0]
        #expect(v1 > v2)
        #expect(v2 < v1)
    }

    @Test("greater/less than or equal")
    func greaterLessOrEqual() {
        let v1 = [11.0, 12.0]
        let v2 = [1.0, 2.0]
        let v3 = [1.0, 2.0]
        #expect(v1 >= v2)
        #expect(v2 <= v1)
        #expect(v2 >= v3)
        #expect(v2 <= v3)
    }
}

@Suite("Vector arithmetic")
struct VectorArithmeticTests {
    let a = [1.0, 2.0, 3.0]
    let b = [4.0, 5.0, 6.0]
    let s = 7.0

    @Test("addition")
    func addition() {
        expectClose(a + b, [5.0, 7.0, 9.0], tol: closeTolerance)
    }

    @Test("substraction")
    func subtraction() {
        expectClose(a - b, [-3.0, -3.0, -3.0], tol: closeTolerance)
    }

    @Test("multiplication")
    func multiplication() {
        expectClose(a .* b, [4.0, 10.0, 18.0], tol: closeTolerance)
    }

    @Test("right division")
    func rightDivision() {
        expectClose(a ./ b, [1.0 / 4.0, 2.0 / 5.0, 3.0 / 6.0], tol: closeTolerance)
    }

    @Test("left division")
    func leftDivision() {
        expectClose(a ./. b, [4.0 / 1.0, 5.0 / 2.0, 6.0 / 3.0], tol: closeTolerance)
    }

    @Test("scalar addition")
    func scalarAddition() {
        let res = [8.0, 9.0, 10.0]
        expectClose(a + s, res, tol: closeTolerance)
        expectClose(s + a, res, tol: closeTolerance)
    }

    @Test("scalar substraction")
    func scalarSubtraction() {
        expectClose(a - s, [-6.0, -5.0, -4.0], tol: closeTolerance)
        expectClose(s - a, [6.0, 5.0, 4.0], tol: closeTolerance)
    }

    @Test("scalar multiplication")
    func scalarMultiplication() {
        let res = [7.0, 14.0, 21.0]
        expectClose(a .* s, res, tol: closeTolerance)
        expectClose(s .* a, res, tol: closeTolerance)
    }

    @Test("scalar right division")
    func scalarRightDivision() {
        expectClose(a ./ s, [1.0 / 7.0, 2.0 / 7.0, 3.0 / 7.0], tol: closeTolerance)
        expectClose(s ./ a, [7.0 / 1.0, 7.0 / 2.0, 7.0 / 3.0], tol: closeTolerance)
    }

    @Test("scalar left division")
    func scalarLeftDivision() {
        expectClose(a ./. s, [7.0 / 1.0, 7.0 / 2.0, 7.0 / 3.0], tol: closeTolerance)
        expectClose(s ./. a, [1.0 / 7.0, 2.0 / 7.0, 3.0 / 7.0], tol: closeTolerance)
    }

    @Test("negation")
    func negation() {
        expectClose(-[1.0, -2.0, 3.0], [-1.0, 2.0, -3.0], tol: closeTolerance)
    }

    @Test("absolute")
    func absolute() {
        expectClose(abs([1.0, -2.0, 3.0]), [1.0, 2.0, 3.0], tol: closeTolerance)
    }

    @Test("threshold")
    func threshold() {
        expectClose(thr([1.0, -2.0, 3.0], 0.0), [1.0, 0.0, 3.0], tol: closeTolerance)
    }

    @Test("dot product")
    func dotProduct() {
        expectClose(a * b, 32.0, tol: closeTolerance)
    }
}

typealias VectorFunction = @Sendable (Vector) -> Vector
typealias ScalarFunction = @Sendable (Double) -> Double

/// One elementwise function: the vector version under test and the scalar function it must match.
struct ElementwiseCase: Sendable, CustomTestStringConvertible {
    let name: String
    let vector: VectorFunction
    let scalar: ScalarFunction
    /// Inputs inside the function's domain (asin and acos are NaN outside [-1, 1]).
    var input: Vector = [1.0, 2.0, 3.0]
    var testDescription: String { name }
}

let exponentialCases: [ElementwiseCase] = [
    .init(name: "exp", vector: { exp($0) }, scalar: { exp($0) }),
    .init(name: "log", vector: { log($0) }, scalar: { log($0) }),
    .init(name: "log10", vector: { log10($0) }, scalar: { log10($0) }),
    .init(name: "log2", vector: { log2($0) }, scalar: { log2($0) }),
    .init(name: "sqrt", vector: { sqrt($0) }, scalar: { sqrt($0) }),
]

let trigonometricCases: [ElementwiseCase] = [
    .init(name: "sin", vector: { sin($0) }, scalar: { sin($0) }),
    .init(name: "cos", vector: { cos($0) }, scalar: { cos($0) }),
    .init(name: "tan", vector: { tan($0) }, scalar: { tan($0) }),
    .init(name: "asin", vector: { asin($0) }, scalar: { asin($0) }, input: [-1.0, -0.5, 0.5, 1.0]),
    .init(name: "acos", vector: { acos($0) }, scalar: { acos($0) }, input: [-1.0, -0.5, 0.5, 1.0]),
    .init(name: "atan", vector: { atan($0) }, scalar: { atan($0) }),
]

@Suite("Vector power and exponential")
struct VectorExponentialTests {
    let vec = [1.0, 2.0, 3.0]

    @Test("power")
    func power() {
        expectClose(vec .^ 3.0, [1.0, 8.0, 27.0], tol: closeTolerance)
    }

    @Test("square")
    func square() {
        expectClose(LASwift.square(vec), [1.0, 4.0, 9.0], tol: closeTolerance)
        expectClose(LASwift.square(vec), vec .^ 2, tol: closeTolerance)
    }

    // exp, log, log10, log2 and sqrt; sqrt also checks the 0.5 power.
    @Test("elementwise function matches scalar function", arguments: exponentialCases)
    func elementwise(_ c: ElementwiseCase) {
        expectClose(c.vector(vec), vec.map(c.scalar), tol: closeTolerance)
    }

    @Test("sqrt equals the 0.5 power")
    func sqrtIsHalfPower() {
        expectClose(sqrt(vec), vec .^ 0.5, tol: closeTolerance)
    }
}

@Suite("Vector trigonometric")
struct VectorTrigonometricTests {
    @Test("elementwise function matches scalar function", arguments: trigonometricCases)
    func elementwise(_ c: ElementwiseCase) {
        expectClose(c.vector(c.input), c.input.map(c.scalar), tol: closeTolerance)
    }
}

@Suite("Vector statistics")
struct VectorStatisticsTests {
    @Test("max")
    func max() {
        expectClose(LASwift.max([1.0, 3.0, 2.0]), 3.0, tol: closeTolerance)
    }

    @Test("maxi")
    func maxi() {
        #expect(LASwift.maxi([1.0, 3.0, 2.0]) == 1)
    }

    @Test("min")
    func min() {
        expectClose(LASwift.min([3.0, 1.0, 2.0]), 1.0, tol: closeTolerance)
    }

    @Test("mini")
    func mini() {
        #expect(LASwift.mini([3.0, 1.0, 2.0]) == 1)
    }

    @Test("mean")
    func mean() {
        expectClose(LASwift.mean([1.0, 2.0, 3.0]), 2.0, tol: closeTolerance)
    }

    @Test("std")
    func std() {
        expectClose(LASwift.std([1.0, 2.0, 3.0]), sqrt(2.0 / 3.0), tol: closeTolerance)
    }

    @Test("sum")
    func sum() {
        expectClose(LASwift.sum([1.0, 2.0, 3.0]), 6.0, tol: closeTolerance)
    }

    @Test("sumsq")
    func sumsq() {
        expectClose(LASwift.sumsq([1.0, 2.0, 3.0]), 14.0, tol: closeTolerance)
    }

    @Test("normalize")
    func normalize() {
        let vec = [1.0, 2.0, 3.0]
        let m = LASwift.mean(vec)
        let s = LASwift.std(vec)
        let res = [(1.0 - m) / s, (2.0 - m) / s, (3.0 - m) / s]
        expectClose(LASwift.normalize(vec), res, tol: closeTolerance)
    }
}
