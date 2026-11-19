//
//  MatrixTests.swift
//  LASwift
//
//  Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
//  All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the BSD license. See the LICENSE file for details.
//

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#endif
import LASwift
import Testing

/// The 2x2 matrix most specs start from.
func sample2x2() -> Matrix {
    Matrix([[1.0, 2.0], [3.0, 4.0]])
}

/// The 3x3 matrix the range-subscript specs start from.
func sample3x3() -> Matrix {
    Matrix([[1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0],
            [7.0, 8.0, 9.0]])
}

@Suite("Matrix construction")
struct MatrixConstructionTests {
    let count = 10

    @Test("ones matrix has correct dimensions")
    func onesDimensions() {
        let m = ones(count, count + 1)
        #expect(m.rows == count)
        #expect(m.cols == count + 1)
    }

    @Test("ones matrix all ones")
    func onesAllOnes() {
        let m = ones(count, count + 1)
        for i in 0..<count {
            for j in 0..<count + 1 {
                expectClose(m[i, j], 1.0, tol: closeTolerance)
            }
        }
    }

    @Test("zeros matrix has correct dimensions")
    func zerosDimensions() {
        let m = zeros(count, count + 1)
        #expect(m.rows == count)
        #expect(m.cols == count + 1)
    }

    @Test("zeros matrix all zeros")
    func zerosAllZeros() {
        let m = zeros(count, count + 1)
        for i in 0..<count {
            for j in 0..<count + 1 {
                expectClose(m[i, j], 0.0, tol: closeTolerance)
            }
        }
    }

    @Test("zeros vectors are equal")
    func zerosEqual() {
        expectClose(zeros(count, count + 1), zeros(count, count + 1))
    }

    @Test("zeros and ones vectors are not equal")
    func zerosOnesNotEqual() {
        #expect(!isClose(zeros(count, count + 1), ones(count, count + 1)))
    }

    @Test("ones like are equal")
    func onesLike() {
        let m3 = zeros(count, count + 1)
        expectClose(ones(like: m3), ones(count, count + 1))
    }

    @Test("zeros like are equal")
    func zerosLike() {
        let m1 = ones(count, count + 1)
        expectClose(zeros(like: m1), zeros(count, count + 1))
    }

    @Test("identity matrix has correct dimensions")
    func identityDimensions() {
        let m = eye(count, count)
        #expect(m.rows == count)
        #expect(m.cols == count)
    }

    @Test("identity matrix ones on diag")
    func identityDiagonal() {
        let m = eye(count, count)
        for i in 0..<count {
            for j in 0..<count {
                expectClose(m[i, j], i == j ? 1.0 : 0.0, tol: closeTolerance)
            }
        }
    }

    let v1 = [1.0, 2.0, 3.0, 4.0, 5.0]

    @Test("diag matrix has correct dimensions")
    func diagDimensions() {
        let v2 = Matrix(v1)
        let m5 = diag(v1)
        let m6 = diag(v2)
        let m7 = diag(v1.count + 2, v1.count, v2)
        #expect(m5.rows == v1.count)
        #expect(m5.cols == v1.count)
        #expect(m6.rows == v1.count)
        #expect(m6.cols == v1.count)
        #expect(m7.rows == v1.count + 2)
        #expect(m7.cols == v1.count)
    }

    @Test("diag matrix correct")
    func diagValues() {
        let v2 = Matrix(v1)
        let m5 = diag(v1)
        let m6 = diag(v2)
        let m7 = diag(v1.count + 2, v1.count, v2)
        for i in 0..<v1.count {
            for j in 0..<v1.count {
                let expected = i == j ? v1[i] : 0.0
                expectClose(m5[i, j], expected, tol: closeTolerance)
                expectClose(m6[i, j], expected, tol: closeTolerance)
                expectClose(m7[i, j], expected, tol: closeTolerance)
            }
        }
    }

    @Test("rand")
    func random() {
        let size = 100
        let m = rand(size, size)
        #expect(m.rows == size)
        #expect(m.cols == size)
        #expect(m.flat.allSatisfy { $0 >= 0.0 && $0 < 1.0 })
    }

    @Test("randn")
    func randomNormal() {
        let m = randn(1000, 1000)
        #expect(m.rows == 1000)
        #expect(m.cols == 1000)
        let means = mean(m)
        let stds = std(m)
        for i in 0..<1000 {
            expectClose(means[i], 0.0, tol: 0.2)
            expectClose(stds[i], 1.0, tol: 0.2)
        }
    }
}

@Suite("Matrix arithmetic")
struct MatrixArithmeticTests {
    let m1 = sample2x2()
    let m2 = Matrix([[5.0, 6.0], [7.0, 8.0]])

    @Test("addition")
    func addition() {
        expectClose(m1 + m2, Matrix([[6.0, 8.0], [10.0, 12.0]]))
    }

    @Test("substraction")
    func subtraction() {
        expectClose(m1 - m2, Matrix([[-4.0, -4.0], [-4.0, -4.0]]))
    }

    @Test("multiplication")
    func multiplication() {
        expectClose(m1 .* m2, Matrix([[5.0, 12.0], [21.0, 32.0]]))
    }

    @Test("right division")
    func rightDivision() {
        let div: Matrix = m1 ./ m2
        expectClose(div, Matrix([[1.0 / 5.0, 2.0 / 6.0], [3.0 / 7.0, 4.0 / 8.0]]))
    }

    @Test("left division")
    func leftDivision() {
        let div: Matrix = m1 ./. m2
        expectClose(div, Matrix([[5.0 / 1.0, 6.0 / 2.0], [7.0 / 3.0, 8.0 / 4.0]]))
    }

    @Test("vector addition")
    func vectorAddition() {
        let v = [5.0, 6.0]
        let res = Matrix([[6.0, 8.0], [8.0, 10.0]])
        expectClose(m1 + v, res)
        expectClose(v + m1, res)
    }

    @Test("vector substraction")
    func vectorSubtraction() {
        let v = [5.0, 6.0]
        expectClose(m1 - v, Matrix([[-4.0, -4.0], [-2.0, -2.0]]))
        expectClose(v - m1, Matrix([[4.0, 4.0], [2.0, 2.0]]))
    }

    @Test("negation")
    func negation() {
        let m = Matrix([[1.0, -2.0], [-3.0, 4.0]])
        expectClose(-m, Matrix([[-1.0, 2.0], [3.0, -4.0]]))
    }

    @Test("absolute")
    func absolute() {
        let m = Matrix([[1.0, -2.0], [-3.0, 4.0]])
        expectClose(abs(m), Matrix([[1.0, 2.0], [3.0, 4.0]]))
    }

    @Test("threshold")
    func threshold() {
        let m = Matrix([[1.0, -2.0], [-3.0, 4.0]])
        expectClose(thr(m, 0.0), Matrix([[1.0, 0.0], [0.0, 4.0]]))
    }
}

@Suite("Matrix-vector arithmetic")
struct MatrixVectorArithmeticTests {
    let m1 = sample2x2()
    let v = [5.0, 6.0]

    @Test("vector multiplication")
    func vectorMultiplication() {
        let res = Matrix([[5.0, 12.0], [15.0, 24.0]])
        expectClose(m1 .* v, res)
        expectClose(v .* m1, res)
    }

    @Test("vector right division")
    func vectorRightDivision() {
        let div1: Matrix = m1 ./ v
        let div2: Matrix = v ./ m1
        expectClose(div1, Matrix([[1.0 / 5.0, 2.0 / 6.0], [3.0 / 5.0, 4.0 / 6.0]]))
        expectClose(div2, Matrix([[5.0 / 1.0, 6.0 / 2.0], [5.0 / 3.0, 6.0 / 4.0]]))
    }

    @Test("vector left division")
    func vectorLeftDivision() {
        let div1: Matrix = m1 ./. v
        let div2: Matrix = v ./. m1
        expectClose(div1, Matrix([[5.0 / 1.0, 6.0 / 2.0], [5.0 / 3.0, 6.0 / 4.0]]))
        expectClose(div2, Matrix([[1.0 / 5.0, 2.0 / 6.0], [3.0 / 5.0, 4.0 / 6.0]]))
    }
}

@Suite("Matrix-scalar arithmetic")
struct MatrixScalarArithmeticTests {
    let m1 = sample2x2()
    let s = 5.0

    @Test("scalar addition")
    func scalarAddition() {
        let res = Matrix([[6.0, 7.0], [8.0, 9.0]])
        expectClose(m1 + s, res)
        expectClose(s + m1, res)
    }

    @Test("scalar substraction")
    func scalarSubtraction() {
        expectClose(m1 - s, Matrix([[-4.0, -3.0], [-2.0, -1.0]]))
        expectClose(s - m1, Matrix([[4.0, 3.0], [2.0, 1.0]]))
    }

    @Test("scalar multiplication")
    func scalarMultiplication() {
        let res = Matrix([[5.0, 10.0], [15.0, 20.0]])
        expectClose(m1 .* s, res)
        expectClose(s .* m1, res)
    }

    @Test("scalar right division")
    func scalarRightDivision() {
        let div1: Matrix = m1 ./ s
        let div2: Matrix = s ./ m1
        expectClose(div1, Matrix([[1.0 / 5.0, 2.0 / 5.0], [3.0 / 5.0, 4.0 / 5.0]]))
        expectClose(div2, Matrix([[5.0 / 1.0, 5.0 / 2.0], [5.0 / 3.0, 5.0 / 4.0]]))
    }

    @Test("scalar left division")
    func scalarLeftDivision() {
        let div1: Matrix = m1 ./. s
        let div2: Matrix = s ./. m1
        expectClose(div1, Matrix([[5.0 / 1.0, 5.0 / 2.0], [5.0 / 3.0, 5.0 / 4.0]]))
        expectClose(div2, Matrix([[1.0 / 5.0, 2.0 / 5.0], [3.0 / 5.0, 4.0 / 5.0]]))
    }
}

// These specs exercise the library's own tolerance-based comparison operators on
// matrices, so they use the operators directly. They go away with the operators.
@Suite("Matrix equality")
struct MatrixEqualityTests {
    @Test("equal")
    func equal() {
        #expect(sample2x2() == sample2x2())
    }

    @Test("not equal")
    func notEqual() {
        let m1 = sample2x2()
        let m2 = Matrix([[1.0, 4.0], [3.0, 2.0]])
        #expect(m1 != m2)
    }

    @Test("equality is exact, not tolerance based")
    func exact() {
        let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
        let m2 = Matrix([[1.0 + 1e-15, 2.0], [3.0, 4.0]])
        #expect(m1 != m2)
        #expect(Matrix([[0.1 + 0.2]]) != Matrix([[0.3]]))
    }

    @Test("same elements with a different shape are not equal")
    func shapeMatters() {
        let flat = [1.0, 2.0, 3.0, 4.0]
        #expect(Matrix(2, 2, flat) != Matrix(1, 4, flat))
        #expect(Matrix(2, 2, flat) != Matrix(4, 1, flat))
    }

    @Test("a matrix holding infinities equals itself")
    func infinity() {
        let m = Matrix([[Double.infinity, -Double.infinity], [1.0, 2.0]])
        #expect(m == m)
        #expect(m == Matrix([[Double.infinity, -Double.infinity], [1.0, 2.0]]))
    }

    @Test("equal matrices hash equally and work as set members and dictionary keys")
    func hashable() {
        let a = sample2x2()
        let b = sample2x2()
        #expect(a.hashValue == b.hashValue)
        let set: Set<Matrix> = [a, b, Matrix([[1.0, 2.0, 3.0, 5.0]])]
        #expect(set.count == 2)
        #expect([a: "x"][b] == "x")
        #expect(Matrix([[0.0]]).hashValue == Matrix([[-0.0]]).hashValue)
    }

    @Test("a matrix holding NaN never equals anything")
    func nan() {
        let m = Matrix([[Double.nan, 1.0]])
        #expect(m != m)
    }
}

@Suite("Matrix subscript")
struct MatrixSubscriptTests {
    @Test("[i,j]")
    func elementSubscript() {
        var m1 = sample2x2()
        #expect(m1[1, 1] == 4.0)
        m1[1, 0] = 10.0
        #expect(m1[1, 0] == 10.0)
    }

    @Test("index")
    func indexSubscript() {
        var m1 = sample2x2()
        #expect(m1[3] == 4.0)
        m1[2] = 10.0
        #expect(m1[2] == 10.0)
        #expect(m1[1, 0] == 10.0)
    }

    @Test("row")
    func rowSubscript() {
        var m1 = sample2x2()
        expectClose(m1[row: 1], [3.0, 4.0])
        m1[row: 0] = [10.0, 20.0]
        expectClose(m1[row: 0], [10.0, 20.0])
        #expect(m1[0, 0] == 10.0)
        #expect(m1[0, 1] == 20.0)
    }

    @Test("column")
    func columnSubscript() {
        var m1 = sample2x2()
        expectClose(m1[col: 1], [2.0, 4.0])
        m1[col: 0] = [10.0, 30.0]
        expectClose(m1[col: 0], [10.0, 30.0])
        #expect(m1[0, 0] == 10.0)
        #expect(m1[1, 0] == 30.0)
    }
}

@Suite("Matrix range-based subscript")
struct MatrixRangeSubscriptTests {
    let m2 = Matrix([[10.0, 11.0],
                     [12.0, 13.0]])

    @Test("[i,j] -> Matrix")
    func submatrix() {
        var m1 = sample3x3()
        expectClose(m1[0, 1].flat, [2.0, 3.0, 5.0, 6.0, 8.0, 9.0])
        m1[1, 0] = m2
        expectClose(m1[1..<3, 0...1].flat, [10.0, 11.0, 12.0, 13.0])
    }

    @Test("closed")
    func closed() {
        var m1 = sample3x3()
        expectClose(m1[1...2, 0...1].flat, [4.0, 5.0, 7.0, 8.0])
        m1[0...1, 1...2] = m2
        expectClose(m1.flat, [1.0, 10.0, 11.0, 4.0, 12.0, 13.0, 7.0, 8.0, 9.0])
    }

    @Test("open")
    func open() {
        var m1 = sample3x3()
        expectClose(m1[1..<3, 0..<2].flat, [4.0, 5.0, 7.0, 8.0])
        m1[0..<2, 1..<3] = m2
        expectClose(m1.flat, [1.0, 10.0, 11.0, 4.0, 12.0, 13.0, 7.0, 8.0, 9.0])
    }

    @Test("partial")
    func partial() {
        var m1 = sample3x3()
        expectClose(m1[1..., ..<2].flat, [4.0, 5.0, 7.0, 8.0])
        m1[1..., 1...] = m2
        expectClose(m1.flat, [1.0, 2.0, 3.0, 4.0, 10.0, 11.0, 7.0, 12.0, 13.0])
    }

    @Test("unbounded")
    func unbounded() {
        var m1 = sample3x3()
        let row = Matrix([[10.0, 11.0, 12.0]])
        expectClose(m1[..., 2...2].flat, [3.0, 6.0, 9.0])
        m1[1...1, ...] = row
        expectClose(m1.flat, [1.0, 2.0, 3.0, 10.0, 11.0, 12.0, 7.0, 8.0, 9.0])
    }
}

@Suite("Matrix map/reduce")
struct MatrixMapReduceTests {
    let squares = Matrix([[1.0, 4.0], [9.0, 16.0]])

    @Test("map")
    func mapClosure() {
        expectClose(map(sample2x2(), { $0 * $0 }), squares)
    }

    @Test("map vec")
    func mapVectorFunction() {
        expectClose(map(sample2x2(), square), squares)
    }

    @Test("reduce rows")
    func reduceRows() {
        let res = [3.0, 7.0]
        expectClose(reduce(sample2x2(), sum), res)
        expectClose(reduce(sample2x2(), sum, .Row), res)
    }

    @Test("reduce cols")
    func reduceColumns() {
        expectClose(reduce(sample2x2(), sum, .Column), [4.0, 6.0])
    }
}

/// One elementwise function: the matrix version under test and the scalar function it must match.
struct MatrixElementwiseCase: Sendable, CustomTestStringConvertible {
    let name: String
    let matrix: @Sendable (Matrix) -> Matrix
    let scalar: ScalarFunction
    /// Inputs inside the function's domain (asin and acos are NaN outside [-1, 1]).
    var input: [[Double]] = [[1.0, 2.0], [3.0, 4.0]]
    var testDescription: String { name }
}

let matrixExponentialCases: [MatrixElementwiseCase] = [
    .init(name: "exp", matrix: { exp($0) }, scalar: { exp($0) }),
    .init(name: "log", matrix: { log($0) }, scalar: { log($0) }),
    .init(name: "log10", matrix: { log10($0) }, scalar: { log10($0) }),
    .init(name: "log2", matrix: { log2($0) }, scalar: { log2($0) }),
    .init(name: "sqrt", matrix: { sqrt($0) }, scalar: { sqrt($0) }),
]

let matrixTrigonometricCases: [MatrixElementwiseCase] = [
    .init(name: "sin", matrix: { sin($0) }, scalar: { sin($0) }),
    .init(name: "cos", matrix: { cos($0) }, scalar: { cos($0) }),
    .init(name: "tan", matrix: { tan($0) }, scalar: { tan($0) }),
    .init(name: "asin", matrix: { asin($0) }, scalar: { asin($0) }, input: [[0.5, -0.5], [1.0, -1.0]]),
    .init(name: "acos", matrix: { acos($0) }, scalar: { acos($0) }, input: [[0.5, -0.5], [1.0, -1.0]]),
    .init(name: "atan", matrix: { atan($0) }, scalar: { atan($0) }),
]

/// The expected result: the scalar function applied to every element.
func expectedElementwise(_ c: MatrixElementwiseCase) -> Matrix {
    Matrix(c.input.map { $0.map(c.scalar) })
}

@Suite("Matrix power and exponential")
struct MatrixExponentialTests {
    @Test("power")
    func power() {
        expectClose(sample2x2() .** 3.0, Matrix([[1.0, 8.0], [27.0, 64.0]]))
    }

    @Test("square")
    func squareTest() {
        let res = Matrix([[1.0, 4.0], [9.0, 16.0]])
        expectClose(square(sample2x2()), res)
        expectClose(sample2x2() .** 2.0, res)
    }

    // exp, log, log10, log2 and sqrt.
    @Test("elementwise function matches scalar function", arguments: matrixExponentialCases)
    func elementwise(_ c: MatrixElementwiseCase) {
        expectClose(c.matrix(Matrix(c.input)), expectedElementwise(c))
    }

    @Test("sqrt equals the 0.5 power")
    func sqrtIsHalfPower() {
        expectClose(sqrt(sample2x2()), sample2x2() .** 0.5)
    }
}

@Suite("Matrix trigonometric")
struct MatrixTrigonometricTests {
    @Test("elementwise function matches scalar function", arguments: matrixTrigonometricCases)
    func elementwise(_ c: MatrixElementwiseCase) {
        expectClose(c.matrix(Matrix(c.input)), expectedElementwise(c))
    }
}

@Suite("Matrix statistics")
struct MatrixStatisticsTests {
    let m1 = Matrix([[1.0, 4.0], [3.0, 2.0]])

    @Test("max")
    func maximum() {
        expectClose(max(m1), [4.0, 3.0], tol: closeTolerance)
        expectClose(max(m1, .Row), [4.0, 3.0], tol: closeTolerance)
        expectClose(max(m1, .Column), [3.0, 4.0], tol: closeTolerance)
    }

    @Test("maxi")
    func maximumIndices() {
        #expect(maxi(m1) == [1, 0])
        #expect(maxi(m1, .Row) == [1, 0])
        #expect(maxi(m1, .Column) == [1, 0])
    }

    @Test("min")
    func minimum() {
        expectClose(min(m1), [1.0, 2.0], tol: closeTolerance)
        expectClose(min(m1, .Row), [1.0, 2.0], tol: closeTolerance)
        expectClose(min(m1, .Column), [1.0, 2.0], tol: closeTolerance)
    }

    @Test("mini")
    func minimumIndices() {
        #expect(mini(m1) == [0, 1])
        #expect(mini(m1, .Row) == [0, 1])
        #expect(mini(m1, .Column) == [0, 1])
    }

    @Test("mean")
    func average() {
        expectClose(mean(m1), [2.5, 2.5], tol: closeTolerance)
        expectClose(mean(m1, .Row), [2.5, 2.5], tol: closeTolerance)
        expectClose(mean(m1, .Column), [2.0, 3.0], tol: closeTolerance)
    }

    @Test("std")
    func deviation() {
        // Sample deviation: divide by N - 1 = 1.
        let res1 = [sqrt(4.5 / 1.0), sqrt(0.5 / 1.0)]
        let res2 = [sqrt(2.0 / 1.0), sqrt(2.0 / 1.0)]
        expectClose(std(m1), res1, tol: closeTolerance)
        expectClose(std(m1, .Row), res1, tol: closeTolerance)
        expectClose(std(m1, .Column), res2, tol: closeTolerance)
    }

    @Test("normalize")
    func normalization() {
        let mr = mean(m1)
        let sr = std(m1, normalization: .population)
        let mc = mean(m1, .Column)
        let sc = std(m1, .Column, normalization: .population)
        let res1 = transpose((transpose(m1) - mr) ./ sr)
        let res2 = (m1 - mc) ./ sc
        expectClose(normalize(m1), res1)
        expectClose(normalize(m1, .Row), res1)
        expectClose(normalize(m1, .Column), res2)
    }

    @Test("sum")
    func total() {
        expectClose(sum(m1), [5.0, 5.0], tol: closeTolerance)
        expectClose(sum(m1, .Row), [5.0, 5.0], tol: closeTolerance)
        expectClose(sum(m1, .Column), [4.0, 6.0], tol: closeTolerance)
    }

    @Test("sumsq")
    func totalSquares() {
        expectClose(sumsq(m1), [17.0, 13.0], tol: closeTolerance)
        expectClose(sumsq(m1, .Row), [17.0, 13.0], tol: closeTolerance)
        expectClose(sumsq(m1, .Column), [10.0, 20.0], tol: closeTolerance)
    }
}

@Suite("Matrix column statistics on non-square matrices")
struct MatrixColumnStatisticsTests {
    /// 3x4, no ties, so the index results are unambiguous.
    let wide = Matrix([[3.0, -1.0, 4.0, 1.0],
                       [5.0, 9.0, 2.0, 6.0],
                       [7.0, 3.0, 5.0, 8.0]])

    @Test("column results on a wide matrix")
    func wideColumns() {
        #expect(max(wide, .Column) == [7.0, 9.0, 5.0, 8.0])
        #expect(min(wide, .Column) == [3.0, -1.0, 2.0, 1.0])
        #expect(maxi(wide, .Column) == [2, 1, 2, 2])
        #expect(mini(wide, .Column) == [0, 0, 1, 0])
        #expect(sum(wide, .Column) == [15.0, 11.0, 11.0, 15.0])
        #expect(sumsq(wide, .Column) == [83.0, 91.0, 45.0, 101.0])
        expectClose(mean(wide, .Column), [5.0, 11.0 / 3.0, 11.0 / 3.0, 5.0])
        // Split into typed steps: the one-expression form exceeds the type checker's budget on Linux.
        let m: Double = 11.0 / 3.0
        let sq: (Double) -> Double = { $0 * $0 }
        let col0: Double = ((4.0 + 0.0 + 4.0) / 2.0).squareRoot()
        let col1: Double = ((sq(-1.0 - m) + sq(9.0 - m) + sq(3.0 - m)) / 2.0).squareRoot()
        let col2: Double = ((sq(4.0 - m) + sq(2.0 - m) + sq(5.0 - m)) / 2.0).squareRoot()
        let col3: Double = ((sq(1.0 - 5.0) + sq(6.0 - 5.0) + sq(8.0 - 5.0)) / 2.0).squareRoot()
        expectClose(std(wide, .Column), [col0, col1, col2, col3])
    }

    @Test("column results on a tall matrix")
    func tallColumns() {
        let tall = transpose(wide)
        #expect(max(tall, .Column) == [4.0, 9.0, 8.0])
        #expect(min(tall, .Column) == [-1.0, 2.0, 3.0])
        #expect(maxi(tall, .Column) == [2, 1, 3])
        #expect(mini(tall, .Column) == [1, 2, 1])
        #expect(sum(tall, .Column) == [7.0, 22.0, 23.0])
        #expect(sumsq(tall, .Column) == [27.0, 146.0, 147.0])
    }

    @Test("column results agree with the row results of the transpose on random data")
    func randomAgreesWithTranspose() {
        for (r, c) in [(7, 5), (5, 7), (1, 6), (6, 1)] {
            let m = rand(r, c)
            let t = transpose(m)
            expectClose(max(m, .Column), max(t, .Row), tol: 1e-12)
            expectClose(min(m, .Column), min(t, .Row), tol: 1e-12)
            expectClose(mean(m, .Column), mean(t, .Row), tol: 1e-12)
            expectClose(sum(m, .Column), sum(t, .Row), tol: 1e-12)
            expectClose(sumsq(m, .Column), sumsq(t, .Row), tol: 1e-12)
            expectClose(std(m, .Column), std(t, .Row), tol: 1e-12)
            #expect(maxi(m, .Column) == maxi(t, .Row))
            #expect(mini(m, .Column) == mini(t, .Row))
        }
    }

    @Test("column statistics do not change the matrix")
    func inputUntouched() {
        let before = wide
        _ = mean(wide, .Column)
        _ = std(wide, .Column)
        _ = maxi(wide, .Column)
        #expect(wide == before)
    }
}

@Suite("Matrix linear algebra")
struct MatrixLinearAlgebraTests {
    @Test("trace")
    func traceTest() {
        let m1 = Matrix([[1.0, 0.0, 2.0],
                         [-1.0, 5.0, 0.0],
                         [0.0, 3.0, -9.0]])
        expectClose(trace(m1), -3.0)
    }

    @Test("transpose")
    func transposeTest() {
        let m1 = Matrix([[1.0, 4.0],
                         [3.0, 2.0]])
        let res = Matrix([[1.0, 3.0],
                          [4.0, 2.0]])
        expectClose(transpose(m1), res)
        expectClose(m1′, res)
        expectClose(m1.T, res)
    }

    @Test("mtimes")
    func mtimesTest() {
        let m1 = Matrix([[1.0, 3.0, 5.0],
                         [2.0, 4.0, 7.0]])
        let m2 = Matrix([[-5.0, 8.0, 11.0],
                         [3.0, 9.0, 21.0],
                         [4.0, 0.0, 8.0]])
        let res = Matrix([[24.0, 35.0, 114.0],
                          [30.0, 52.0, 162.0]])
        expectClose(m1 * m2, res)
        expectClose(mtimes(m1, m2), res)
    }

    @Test("mpower")
    func mpowerTest() {
        let m1 = sample2x2()
        let res1 = Matrix([[7.0, 10.0],
                           [15.0, 22.0]])
        let res2 = inv(m1 * m1)
        let identity = Matrix([[1.0, 0.0],
                               [0.0, 1.0]])
        expectClose(m1 ** 1, m1)
        expectClose(m1 ** 2, res1)
        expectClose(m1 ** -2, res2)
        expectClose(m1 ** 0, identity)
    }

    @Test("inverse")
    func inverse() {
        let m1 = Matrix([[1.0, 0.0, 2.0],
                         [-1.0, 5.0, 0.0],
                         [0.0, 3.0, -9.0]])
        let res = Matrix([[0.88235294117647067, -0.11764705882352944, 0.19607843137254904],
                          [0.17647058823529416, 0.17647058823529413, 0.03921568627450981],
                          [0.058823529411764663, 0.058823529411764719, -0.098039215686274522]])
        expectClose(inv(m1), res)
        expectClose(mpower(m1, -1), res)
        expectClose(m1 ** -1, res)
        expectClose(inv(m1) * m1, eye(3, 3))
    }

    @Test("eigen")
    func eigen() {
        let m1 = Matrix([[1.0000, 0.5000, 0.3333, 0.2500],
                         [0.5000, 1.0000, 0.6667, 0.5000],
                         [0.3333, 0.6667, 1.0000, 0.7500],
                         [0.2500, 0.5000, 0.7500, 1.0000]])
        let e1 = eig(m1)
        expectClose(m1 * e1.V, e1.V * e1.D)
        let m3 = Matrix([[0, 1],
                         [-2, -3]])
        let e2 = eig(m3)
        expectClose(m3 * e2.V, e2.V * e2.D)
        let v3 = Matrix([[-1.0, 0.0],
                         [0.0, -2.0]])
        expectClose(e2.D, v3)
    }

    @Test("svd")
    func svdTest() {
        let m1 = Matrix([[1.0, 2.0],
                         [3.0, 4.0],
                         [5.0, 6.0],
                         [7.0, 8.0]])
        let usv = svd(m1)
        expectClose(usv.U * usv.S * usv.V′, m1)
    }

    @Test("chol")
    func cholesky() {
        let m1 = Matrix([[1, 1, 1, 1, 1],
                         [1, 2, 3, 4, 5],
                         [1, 3, 6, 10, 15],
                         [1, 4, 10, 20, 35],
                         [1, 5, 15, 35, 70]])
        let u = chol(m1)
        expectClose(u′ * u, m1)
        let l = chol(m1, .Lower)
        expectClose(l * l′, m1)
    }

    @Test("det")
    func determinant() {
        let m = Matrix([[1.44, -7.84, -4.39, 4.53],
                        [-9.96, -0.28, -3.24, 3.83],
                        [-7.55, 3.24, 6.27, -6.64],
                        [8.34, 8.09, 5.28, 2.06]])
        expectClose(det(m), -4044.7754, tol: closeTolerance)
    }

    @Test("lstsq")
    func leastSquares() {
        let a1 = Matrix([[1.44, -7.84, -4.39, 4.53],
                         [-9.96, -0.28, -3.24, 3.83],
                         [-7.55, 3.24, 6.27, -6.64],
                         [8.34, 8.09, 5.28, 2.06],
                         [7.08, 2.52, 0.74, -2.47],
                         [-5.45, -5.70, -1.19, 4.70]])
        let b1 = Matrix([[8.58, 9.35],
                         [8.26, -4.43],
                         [8.48, -0.70],
                         [-5.28, -0.26],
                         [5.72, -7.36],
                         [8.93, -2.52]])
        let c2 = Matrix([[-0.4506, 0.2497],
                         [-0.8491, -0.9020],
                         [0.7066, 0.6323],
                         [0.1288, 0.1351]])
        let d2 = Matrix([[195.3616, 107.05746]])

        let (c1, d1) = lstsqr(a1, b1)

        // Solution matrix and residue matrix, to 0.001.
        expectClose(c1, c2, tol: 0.001)
        expectClose(d1, d2, tol: 0.001)
    }
}

@Suite("Matrix concatenation")
struct MatrixConcatenationTests {
    let m1 = sample2x2()
    let m2 = Matrix([[5.0, 6.0],
                     [7.0, 8.0]])

    @Test("horizontal scalar append")
    func horizontalScalarAppend() {
        expectClose(m1 === 5.0, Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 5.0]]))
    }

    @Test("horizontal scalar prepend")
    func horizontalScalarPrepend() {
        expectClose(5.0 === m1, Matrix([[5.0, 5.0], [1.0, 2.0], [3.0, 4.0]]))
    }

    @Test("horizontal vector append")
    func horizontalVectorAppend() {
        let v = [5.0, 6.0]
        let res = Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
        expectClose(m1 === v, res)
        expectClose(append(m1, rows: [v]), res)
        expectClose(append(m1, rows: Matrix([v])), res)
    }

    @Test("horizontal vector prepend")
    func horizontalVectorPrepend() {
        let v = [5.0, 6.0]
        let res = Matrix([[5.0, 6.0], [1.0, 2.0], [3.0, 4.0]])
        expectClose(v === m1, res)
        expectClose(prepend(m1, rows: [v]), res)
        expectClose(prepend(m1, rows: Matrix([v])), res)
    }

    @Test("horizontal matrix append")
    func horizontalMatrixAppend() {
        expectClose(m1 === m2, Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0], [7.0, 8.0]]))
    }

    @Test("horizontal matrix prepend")
    func horizontalMatrixPrepend() {
        expectClose(m2 === m1, Matrix([[5.0, 6.0], [7.0, 8.0], [1.0, 2.0], [3.0, 4.0]]))
    }

    @Test("horizontal matrix insert")
    func horizontalMatrixInsert() {
        expectClose(insert(m1, rows: m2, at: 1),
                    Matrix([[1.0, 2.0], [5.0, 6.0], [7.0, 8.0], [3.0, 4.0]]))
    }

    @Test("vertical scalar append")
    func verticalScalarAppend() {
        expectClose(m1 ||| 5.0, Matrix([[1.0, 2.0, 5.0], [3.0, 4.0, 5.0]]))
    }

    @Test("vertical scalar prepend")
    func verticalScalarPrepend() {
        expectClose(5.0 ||| m1, Matrix([[5.0, 1.0, 2.0], [5.0, 3.0, 4.0]]))
    }

    @Test("vertical vector append")
    func verticalVectorAppend() {
        let v = [5.0, 6.0]
        let res = Matrix([[1.0, 2.0, 5.0], [3.0, 4.0, 6.0]])
        expectClose(m1 ||| v, res)
        expectClose(append(m1, cols: [v]), res)
        expectClose(append(m1, cols: Matrix(v)), res)
    }

    @Test("vertical vector prepend")
    func verticalVectorPrepend() {
        let v = [5.0, 6.0]
        let res = Matrix([[5.0, 1.0, 2.0], [6.0, 3.0, 4.0]])
        expectClose(v ||| m1, res)
        expectClose(prepend(m1, cols: [v]), res)
        expectClose(prepend(m1, cols: Matrix(v)), res)
    }

    @Test("vertical matrix append")
    func verticalMatrixAppend() {
        expectClose(m1 ||| m2, Matrix([[1.0, 2.0, 5.0, 6.0], [3.0, 4.0, 7.0, 8.0]]))
    }

    @Test("vertical matrix prepend")
    func verticalMatrixPrepend() {
        expectClose(m2 ||| m1, Matrix([[5.0, 6.0, 1.0, 2.0], [7.0, 8.0, 3.0, 4.0]]))
    }

    @Test("vertical matrix insert")
    func verticalMatrixInsert() {
        expectClose(insert(m1, cols: m2, at: 1), Matrix([[1.0, 5.0, 6.0, 2.0], [3.0, 7.0, 8.0, 4.0]]))
    }

    @Test("vstack")
    func vstackTest() {
        let a = Matrix([[1.0, 2.0, 3.0],
                        [4.0, 5.0, 6.0]])
        let b = Matrix([[7.0, 8.0, 9.0],
                        [10.0, 11.0, 12.0]])
        let res = Matrix([[1.0, 2.0, 3.0],
                          [4.0, 5.0, 6.0],
                          [7.0, 8.0, 9.0],
                          [10.0, 11.0, 12.0]])
        expectClose(vstack([a, b]), res)
    }

    @Test("hstack")
    func hstackTest() {
        let a = Matrix([[1.0, 2.0, 3.0],
                        [4.0, 5.0, 6.0]])
        let b = Matrix([[7.0, 8.0, 9.0],
                        [10.0, 11.0, 12.0]])
        let res = Matrix([[1.0, 2.0, 3.0, 7.0, 8.0, 9.0],
                          [4.0, 5.0, 6.0, 10.0, 11.0, 12.0]])
        expectClose(hstack([a, b]), res)
    }
}

@Suite("matrix convolution")
struct MatrixConvolutionTests {
    let kernel = Matrix([[1, 1, 1],
                         [1, 1, 1],
                         [1, 1, 1]])

    @Test("should return same matrix if convolving a matrix of 0's")
    func convolveZeros() {
        let m1 = Matrix([[0, 0, 0, 0, 0],
                         [0, 0, 0, 0, 0],
                         [0, 0, 0, 0, 0],
                         [0, 0, 0, 0, 0]])
        expectClose(convolve(m1, kernel), m1)
    }

    @Test("should convolve a matrix correctly")
    func convolveIdentity() {
        let m1 = Matrix([[1, 0, 0, 0, 0],
                         [0, 1, 0, 0, 0],
                         [0, 0, 1, 0, 0],
                         [0, 0, 0, 1, 0],
                         [0, 0, 0, 0, 1]])
        expectClose(convolve(m1, kernel),
                    Matrix([[2.0, 2.0, 1.0, 0.0, 0.0],
                            [2.0, 3.0, 2.0, 1.0, 0.0],
                            [1.0, 2.0, 3.0, 2.0, 1.0],
                            [0.0, 1.0, 2.0, 3.0, 2.0],
                            [0.0, 0.0, 1.0, 2.0, 2.0]]))
    }
}

@Suite("matrix slicing")
struct MatrixSlicingTests {
    @Test("basic tests")
    func basicSlicing() {
        let m1 = Matrix([[0, 1, 2, 3, 4],
                         [5, 6, 7, 8, 9],
                         [10, 11, 12, 13, 14],
                         [15, 16, 17, 18, 19]])
        let res1 = Matrix([[0, 1, 2],
                           [5, 6, 7],
                           [10, 11, 12]])
        let res2 = Matrix([[12, 13, 14],
                           [17, 18, 19]])
        let res3 = Matrix([[10, 11, 12, 13, 14],
                           [5, 6, 7, 8, 9]])
        let res4 = Matrix([[2, 1],
                           [7, 6],
                           [12, 11],
                           [17, 16]])
        let res5 = Matrix([[9, 7, 5],
                           [4, 2, 0]])
        let res6 = Matrix([[18, 15],
                           [8, 5]])
        expectClose(m1 ?? (.All, .All), m1)
        expectClose(m1[(.All, .All)], m1)
        expectClose(m1 ?? (.Take(3), .DropLast(2)), res1)
        expectClose(m1 ?? (.DropLast(1), .Take(3)), res1)
        expectClose(m1 ?? (.TakeLast(2), .TakeLast(3)), res2)
        expectClose(m1 ?? (.Drop(2), .Drop(2)), res2)
        expectClose(m1 ?? (.Pos([2, 1]), .All), res3)
        expectClose(m1 ?? (.All, .Pos([2, 1])), res4)
        expectClose(m1 ?? (.PosCyc([-7, 80]), .Range(4, -2, 0)), res5)
        expectClose(m1 ?? (.Range(3, -2, 0), .PosCyc([-7, 80])), res6)
    }
}

// Precondition failures end the process, so they are checked with exit tests, which
// Swift Testing supports on macOS and Linux only (not on iOS, tvOS, watchOS or visionOS).
// The closures cannot capture, so each builds its own inputs. These replace the old
// `throwAssertion()` expectations, which were compiled out of the package build.
#if os(macOS) || os(Linux)
func slicingSample() -> Matrix {
    Matrix([[0, 1, 2, 3, 4],
            [5, 6, 7, 8, 9],
            [10, 11, 12, 13, 14],
            [15, 16, 17, 18, 19]])
}

/// An exit test passes on any crash, so check the crash is the precondition we expect.
func expectStderr(_ result: ExitTest.Result?, contains text: String,
                  sourceLocation: SourceLocation = #_sourceLocation) {
    let stderr = String(decoding: result?.standardErrorContent ?? [], as: UTF8.self)
    #expect(stderr.contains(text), "stderr was: \(stderr)", sourceLocation: sourceLocation)
}

@Suite("Matrix column access")
struct MatrixColumnAccessTests {
    @Test("reads columns of a wide matrix")
    func readWide() {
        let m = Matrix([[1.0, 2.0, 3.0, 4.0], [5.0, 6.0, 7.0, 8.0]])
        #expect(m[col: 0] == [1.0, 5.0])
        #expect(m[col: 2] == [3.0, 7.0])
        #expect(m[col: 3] == [4.0, 8.0])
    }

    @Test("reads columns of a tall matrix")
    func readTall() {
        let m = Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0], [7.0, 8.0]])
        #expect(m[col: 0] == [1.0, 3.0, 5.0, 7.0])
        #expect(m[col: 1] == [2.0, 4.0, 6.0, 8.0])
    }

    @Test("writes a column of a wide matrix and leaves the others alone")
    func writeWide() {
        var m = Matrix([[1.0, 2.0, 3.0, 4.0], [5.0, 6.0, 7.0, 8.0]])
        m[col: 2] = [30.0, 70.0]
        #expect(m == Matrix([[1.0, 2.0, 30.0, 4.0], [5.0, 6.0, 70.0, 8.0]]))
        m[col: 0] = [-1.0, -5.0]
        #expect(m == Matrix([[-1.0, 2.0, 30.0, 4.0], [-5.0, 6.0, 70.0, 8.0]]))
        m[col: 3] = [0.0, 0.0]
        #expect(m == Matrix([[-1.0, 2.0, 30.0, 0.0], [-5.0, 6.0, 70.0, 0.0]]))
    }

    @Test("writes a column of a tall matrix and leaves the others alone")
    func writeTall() {
        var m = Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0], [7.0, 8.0]])
        m[col: 1] = [20.0, 40.0, 60.0, 80.0]
        #expect(m == Matrix([[1.0, 20.0], [3.0, 40.0], [5.0, 60.0], [7.0, 80.0]]))
        m[col: 0] = [0.0, 0.0, 0.0, 0.0]
        #expect(m == Matrix([[0.0, 20.0], [0.0, 40.0], [0.0, 60.0], [0.0, 80.0]]))
    }

    @Test("writing a column does not change a copy")
    func writeCopy() {
        let original = sample2x2()
        var copy = original
        copy[col: 1] = [9.0, 9.0]
        #expect(original == sample2x2())
    }

    @Test("a negative column index fails the precondition when reading", .exitTests)
    func negativeRead() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = sample2x2()[col: -1]
        }
        expectStderr(result, contains: "Invalid index")
    }

    @Test("a negative column index fails the precondition when writing", .exitTests)
    func negativeWrite() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            var m = sample2x2()
            m[col: -1] = [1.0, 2.0]
        }
        expectStderr(result, contains: "Invalid index")
    }

    @Test("a column index past the last column fails the precondition", .exitTests)
    func pastEnd() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = sample2x2()[col: 2]
        }
        expectStderr(result, contains: "Invalid index")
    }

    @Test("writing a column of the wrong length fails the precondition", .exitTests)
    func wrongLength() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            var m = sample2x2()
            m[col: 0] = [1.0, 2.0, 3.0]
        }
        expectStderr(result, contains: "Input dimensions must agree")
    }
}

@Suite("Matrix precondition failures")
struct MatrixPreconditionTests {
    @Test("should throw precondition failure if trying to convolve a matrix with a larger kernel", .exitTests)
    func convolveWithLargerKernel() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            let kernel = Matrix([[0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0]])
            let m1 = Matrix([[1, 1, 1],
                             [1, 1, 1],
                             [1, 1, 1]])
            _ = convolve(m1, kernel)
        }
        expectStderr(result, contains: "The kernel matrix needs to be smaller")
    }

    @Test("inverse of a non-square matrix", .exitTests)
    func inverseNonSquare() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = inv(Matrix([[1.0, 0.0, 2.0], [-1.0, 5.0, 0.0]]))
        }
        expectStderr(result, contains: "Matrix dimensions must agree")
    }

    @Test("inverse of a singular matrix", .exitTests)
    func inverseSingular() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = inv(ones(3, 3))
        }
        expectStderr(result, contains: "Matrix is non invertible")
    }

    @Test("eigen of a non-square matrix", .exitTests)
    func eigenNonSquare() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = eig(Matrix([[1.0, 0.0, 2.0], [-1.0, 5.0, 0.0]]))
        }
        expectStderr(result, contains: "Matrix dimensions must agree")
    }

    // The slicing inputs in "basic tests": rows 0..<4, columns 0..<5.
    @Test("slicing with out-of-range extractors", .exitTests)
    func slicingOutOfRange() async {
        expectStderr(await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) { _ = slicingSample() ?? (.Range(4, -2, 0), .All) },
                     contains: "Range out of bounds")
        expectStderr(await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) { _ = slicingSample() ?? (.Range(3, -2, -1), .All) },
                     contains: "Range out of bounds")
        expectStderr(await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) { _ = slicingSample() ?? (.All, .Range(5, -2, 0)) },
                     contains: "Range out of bounds")
        expectStderr(await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) { _ = slicingSample() ?? (.All, .Range(3, -2, -1)) },
                     contains: "Range out of bounds")
        expectStderr(await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) { _ = slicingSample() ?? (.Range(0, -2, 4), .All) },
                     contains: "Range out of bounds")
        expectStderr(await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) { _ = slicingSample() ?? (.Range(-1, -2, 3), .All) },
                     contains: "Range out of bounds")
        expectStderr(await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) { _ = slicingSample() ?? (.All, .Range(0, -2, 5)) },
                     contains: "Range out of bounds")
        expectStderr(await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) { _ = slicingSample() ?? (.All, .Range(-1, -2, 3)) },
                     contains: "Range out of bounds")
        expectStderr(await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) { _ = slicingSample() ?? (.Take(5), .All) },
                     contains: "Range out of bounds")
        expectStderr(await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) { _ = slicingSample() ?? (.Take(-1), .All) },
                     contains: "Range out of bounds")
        expectStderr(await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) { _ = slicingSample() ?? (.All, .Take(6)) },
                     contains: "Range out of bounds")
        expectStderr(await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) { _ = slicingSample() ?? (.All, .Take(-1)) },
                     contains: "Range out of bounds")
        expectStderr(await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) { _ = slicingSample() ?? (.Drop(5), .All) },
                     contains: "Range out of bounds")
        expectStderr(await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) { _ = slicingSample() ?? (.Drop(-1), .All) },
                     contains: "Range out of bounds")
        expectStderr(await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) { _ = slicingSample() ?? (.All, .Drop(6)) },
                     contains: "Range out of bounds")
        expectStderr(await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) { _ = slicingSample() ?? (.All, .Drop(-1)) },
                     contains: "Range out of bounds")
    }
}
#endif

private func requireSendable<T: Sendable>(_: T) {}

@Suite("Matrix value semantics")
struct MatrixValueSemanticsTests {
    @Test("Matrix is Sendable")
    func isSendable() {
        requireSendable(sample2x2())
    }

    @Test("mutating a copy leaves the original unchanged")
    func copyThenMutate() {
        let original = sample2x2()
        var copy = original
        copy[0, 0] = 99.0
        copy[row: 1] = [7.0, 8.0]
        #expect(original[0, 0] == 1.0)
        #expect(original[row: 1] == [3.0, 4.0])
        #expect(copy[0, 0] == 99.0)
    }

    @Test("unbounded range subscript returns an independent matrix")
    func unboundedSubscriptCopies() {
        let source = sample3x3()
        var result = source[..., ...]
        result[0, 0] = 99.0
        #expect(source[0, 0] == 1.0)
        #expect(result[0, 0] == 99.0)
    }

    @Test("slice with all rows and columns returns an independent matrix")
    func allAllSliceCopies() {
        let source = sample3x3()
        var result = slice(source, (.All, .All))
        result[1, 1] = 99.0
        #expect(source[1, 1] == 5.0)
        #expect(result[1, 1] == 99.0)
    }

    @Test("vstack of one matrix returns an independent matrix")
    func singleVstackCopies() {
        let source = sample2x2()
        var result = vstack([source])
        result[0, 1] = 99.0
        #expect(source[0, 1] == 2.0)
        #expect(result[0, 1] == 99.0)
    }

    @Test("hstack of one matrix returns an independent matrix")
    func singleHstackCopies() {
        let source = sample2x2()
        var result = hstack([source])
        result[1, 0] = 99.0
        #expect(source[1, 0] == 3.0)
        #expect(result[1, 0] == 99.0)
    }

    @Test("vstack and hstack of several matrices keep every input unchanged")
    func multiStackLeavesInputs() {
        let a = sample2x2()
        let b = Matrix([[5.0, 6.0]])
        let c = Matrix([[7.0, 8.0], [9.0, 10.0]])
        let tall = vstack([a, b, a])
        #expect(tall.rows == 5 && tall.cols == 2)
        #expect(tall.flat == [1, 2, 3, 4, 5, 6, 1, 2, 3, 4])
        let wide = hstack([a, c, a])
        #expect(wide.rows == 2 && wide.cols == 6)
        #expect(wide.flat == [1, 2, 7, 8, 1, 2, 3, 4, 9, 10, 3, 4])
        #expect(a.flat == [1, 2, 3, 4])
        #expect(c.flat == [7, 8, 9, 10])
    }
}
