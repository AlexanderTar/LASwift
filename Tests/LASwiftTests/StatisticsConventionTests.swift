//
//  StatisticsConventionTests.swift
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

// Reference values: NumPy `std(..., ddof: 1)` / `std(..., ddof: 0)`, which equal Matlab's
// `std(x)` (N - 1) and `std(x, 1)` (N).
@Suite("Standard deviation normalisation")
struct StdNormalizationTests {
    @Test("vector std defaults to the sample deviation (N - 1)")
    func vectorDefault() {
        expectClose(std([1.0, 2.0, 3.0, 4.0]), 1.2909944487358056)
    }

    @Test("vector std with population normalisation divides by N")
    func vectorPopulation() {
        expectClose(std([1.0, 2.0, 3.0, 4.0], normalization: .population), 1.118033988749895)
        expectClose(std([1.0, 2.0, 3.0, 4.0], normalization: .sample), 1.2909944487358056)
    }

    @Test("std of one element is 0 for both normalisations")
    func singleElement() {
        #expect(std([5.0]) == 0.0)
        #expect(std([5.0], normalization: .population) == 0.0)
    }

    let tall = Matrix([[1.0, 10.0], [2.0, 20.0], [6.0, 60.0]])

    @Test("matrix std defaults to the sample deviation")
    func matrixDefault() {
        expectClose(std(tall, .Column), [2.6457513110645907, 26.457513110645905])
        expectClose(std(tall, .Row), [6.363961030678928, 12.727922061357855, 38.18376618407357])
    }

    @Test("matrix std with population normalisation")
    func matrixPopulation() {
        expectClose(std(tall, .Column, normalization: .population), [2.160246899469287, 21.602468994692867])
        expectClose(std(tall, .Row, normalization: .population), [4.5, 9.0, 27.0])
    }

    @Test("normalize on columns keeps the shape")
    func normalizeColumnShape() {
        let n = normalize(tall, .Column)
        #expect(n.rows == 3)
        #expect(n.cols == 2)
        let col = [-0.9258200997725514, -0.4629100498862757, 1.3887301496588271]
        expectClose(n, Matrix([[col[0], col[0]], [col[1], col[1]], [col[2], col[2]]]), tol: 1e-12)
    }

    @Test("normalize on rows keeps the shape")
    func normalizeRowShape() {
        let n = normalize(tall, .Row)
        #expect(n.rows == 3)
        #expect(n.cols == 2)
        expectClose(n, Matrix([[-1.0, 1.0], [-1.0, 1.0], [-1.0, 1.0]]))
    }
}

@Suite("Statistics of empty input")
struct EmptyStatisticsTests {
    @Test("max of an empty vector is a precondition failure")
    func maxEmptyVector() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = max([Double]())
        }
        let stderr = String(decoding: result?.standardErrorContent ?? [], as: UTF8.self)
        #expect(stderr.contains("non-empty"), "stderr was: \(stderr)")
    }

    @Test("min of an empty vector is a precondition failure")
    func minEmptyVector() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = min([Double]())
        }
        let stderr = String(decoding: result?.standardErrorContent ?? [], as: UTF8.self)
        #expect(stderr.contains("non-empty"), "stderr was: \(stderr)")
    }

    @Test("maxi of an empty vector is a precondition failure")
    func maxiEmptyVector() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = maxi([Double]())
        }
        let stderr = String(decoding: result?.standardErrorContent ?? [], as: UTF8.self)
        #expect(stderr.contains("non-empty"), "stderr was: \(stderr)")
    }

    @Test("mini of an empty vector is a precondition failure")
    func miniEmptyVector() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = mini([Double]())
        }
        let stderr = String(decoding: result?.standardErrorContent ?? [], as: UTF8.self)
        #expect(stderr.contains("non-empty"), "stderr was: \(stderr)")
    }

    @Test("mean of an empty vector is a precondition failure")
    func meanEmptyVector() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = mean([Double]())
        }
        let stderr = String(decoding: result?.standardErrorContent ?? [], as: UTF8.self)
        #expect(stderr.contains("non-empty"), "stderr was: \(stderr)")
    }

    @Test("std of an empty vector is a precondition failure")
    func stdEmptyVector() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = std([Double]())
        }
        let stderr = String(decoding: result?.standardErrorContent ?? [], as: UTF8.self)
        #expect(stderr.contains("non-empty"), "stderr was: \(stderr)")
    }

    @Test("max of an empty matrix is a precondition failure")
    func maxEmptyMatrix() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = max(Matrix(0, 0, []))
        }
        let stderr = String(decoding: result?.standardErrorContent ?? [], as: UTF8.self)
        #expect(stderr.contains("non-empty"), "stderr was: \(stderr)")
    }

    @Test("min of an empty matrix is a precondition failure")
    func minEmptyMatrix() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = min(Matrix(0, 0, []))
        }
        let stderr = String(decoding: result?.standardErrorContent ?? [], as: UTF8.self)
        #expect(stderr.contains("non-empty"), "stderr was: \(stderr)")
    }

    @Test("maxi of an empty matrix is a precondition failure")
    func maxiEmptyMatrix() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = maxi(Matrix(0, 0, []))
        }
        let stderr = String(decoding: result?.standardErrorContent ?? [], as: UTF8.self)
        #expect(stderr.contains("non-empty"), "stderr was: \(stderr)")
    }

    @Test("mini of an empty matrix is a precondition failure")
    func miniEmptyMatrix() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = mini(Matrix(0, 0, []))
        }
        let stderr = String(decoding: result?.standardErrorContent ?? [], as: UTF8.self)
        #expect(stderr.contains("non-empty"), "stderr was: \(stderr)")
    }

    @Test("mean of an empty matrix is a precondition failure")
    func meanEmptyMatrix() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = mean(Matrix(0, 0, []))
        }
        let stderr = String(decoding: result?.standardErrorContent ?? [], as: UTF8.self)
        #expect(stderr.contains("non-empty"), "stderr was: \(stderr)")
    }

    @Test("std of an empty matrix is a precondition failure")
    func stdEmptyMatrix() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            _ = std(Matrix(0, 0, []))
        }
        let stderr = String(decoding: result?.standardErrorContent ?? [], as: UTF8.self)
        #expect(stderr.contains("non-empty"), "stderr was: \(stderr)")
    }
}

@Suite("NaN in index statistics")
struct NaNIndexTests {
    @Test("maxi and mini skip NaN elements")
    func skipsNaN() {
        let n = Double.nan
        #expect(maxi([1.0, n, 3.0]) == 2)
        #expect(maxi([n, 5.0, 2.0]) == 1)
        #expect(mini([1.0, n, 3.0]) == 0)
        #expect(mini([n, 5.0, 2.0]) == 2)
    }
}

@Suite("Signed zeros")
struct SignedZeroTests {
    @Test("det of a singular matrix is +0", arguments: [
        Matrix([[1.0, 2.0], [2.0, 4.0]]),
        Matrix([[0.0, 0.0], [0.0, 0.0]]),
        Matrix([[0.0, 1.0], [0.0, 0.0]]),
        Matrix([[0.0, 0.0], [1.0, 0.0]]),
        Matrix([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]),
    ])
    func singularDeterminant(_ A: Matrix) {
        let d = det(A)
        #expect(d == 0.0)
        #expect(d.sign == .plus, "det was \(d)")
    }

    @Test("1 - A has +0 where A is 1")
    func scalarMinusMatrix() {
        let r = 1.0 - Matrix([[1.0, 2.0], [0.0, 1.0]])
        #expect(r.flat == [0.0, -1.0, 1.0, 0.0])
        #expect(r.flat.filter { $0 == 0.0 }.allSatisfy { $0.sign == .plus }, "\(r.flat)")
    }

    @Test("1 - a has +0 where a is 1")
    func scalarMinusVector() {
        let r = 1.0 - [1.0, 2.0, 1.0]
        #expect(r == [0.0, -1.0, 0.0])
        #expect(r.filter { $0 == 0.0 }.allSatisfy { $0.sign == .plus }, "\(r)")
    }
}
