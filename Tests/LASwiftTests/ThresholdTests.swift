//
//  ThresholdTests.swift
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

@Suite("Threshold")
struct ThresholdTests {
    @Test("vector values below t become 0")
    func vectorBelowThreshold() {
        expectClose(thr([1.0, -2.0, 3.0, 0.5], 1.0), [1.0, 0.0, 3.0, 0.0])
        expectClose(thr([1.0, -2.0, 3.0, 0.5], 2.0), [0.0, 0.0, 3.0, 0.0])
    }

    @Test("values equal to t are kept")
    func boundaryIsKept() {
        expectClose(thr([1.0, 2.0, 3.0], 2.0), [0.0, 2.0, 3.0])
    }

    @Test("negative threshold keeps negative values at or above it")
    func negativeThreshold() {
        expectClose(thr([-3.0, -1.0, 0.0, 2.0], -1.5), [0.0, -1.0, 0.0, 2.0])
    }

    @Test("NaN is kept")
    func nanIsKept() {
        let result = thr([Double.nan, 1.0], 0.5)
        #expect(result[0].isNaN)
        #expect(result[1] == 1.0)
    }

    @Test("matrix values below t become 0")
    func matrixBelowThreshold() {
        expectClose(thr(Matrix([[1.0, 2.0], [3.0, 4.0]]), 2.5), Matrix([[0.0, 0.0], [3.0, 4.0]]))
    }
}
