//
//  ConvolutionTests.swift
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

// Expected values come from SciPy 1.18.1: `scipy.signal.convolve2d(A, K, mode='same')`,
// which equals Matlab's `conv2(A, K, 'same')`.
@Suite("True 2-D convolution")
struct ConvolutionTests {
    let A = Matrix([[1.0, 2.0, 3.0, 4.0, 5.0],
                    [6.0, 7.0, 8.0, 9.0, 10.0],
                    [11.0, 12.0, 13.0, 14.0, 15.0],
                    [16.0, 17.0, 18.0, 19.0, 20.0]])

    @Test("3x3 asymmetric kernel flips the kernel and keeps the borders")
    func threeByThree() {
        let K = Matrix([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]])
        expectClose(convolve(A, K), Matrix([
            [32.0, 68.0, 89.0, 110.0, 96.0],
            [114.0, 219.0, 264.0, 309.0, 252.0],
            [249.0, 444.0, 489.0, 534.0, 417.0],
            [320.0, 539.0, 578.0, 617.0, 460.0]]))
    }

    @Test("3x5 kernel does not take the 3x3 fast path")
    func threeByFive() {
        let B = Matrix(5, 7, (1...35).map(Double.init))
        let K = Matrix([[1.0, 0.0, 2.0, 0.0, 1.0], [0.0, 3.0, 0.0, 4.0, 0.0], [2.0, 0.0, 1.0, 0.0, 3.0]])
        expectClose(convolve(B, K), Matrix([
            [32.0, 42.0, 60.0, 71.0, 82.0, 78.0, 64.0],
            [81.0, 122.0, 153.0, 170.0, 187.0, 166.0, 135.0],
            [144.0, 213.0, 272.0, 289.0, 306.0, 264.0, 212.0],
            [207.0, 304.0, 391.0, 408.0, 425.0, 362.0, 289.0],
            [160.0, 282.0, 358.0, 371.0, 384.0, 339.0, 242.0]]))
    }

    @Test("1x3 kernel")
    func oneByThree() {
        let K = Matrix([[1.0, 2.0, 3.0]])
        expectClose(convolve(A, K), Matrix([
            [4.0, 10.0, 16.0, 22.0, 22.0],
            [19.0, 40.0, 46.0, 52.0, 47.0],
            [34.0, 70.0, 76.0, 82.0, 72.0],
            [49.0, 100.0, 106.0, 112.0, 97.0]]))
    }

    @Test("3x1 kernel")
    func threeByOne() {
        let K = Matrix([[1.0], [2.0], [3.0]])
        expectClose(convolve(A, K), Matrix([
            [8.0, 11.0, 14.0, 17.0, 20.0],
            [26.0, 32.0, 38.0, 44.0, 50.0],
            [56.0, 62.0, 68.0, 74.0, 80.0],
            [65.0, 70.0, 75.0, 80.0, 85.0]]))
    }

    @Test("1x1 kernel scales the matrix")
    func oneByOne() {
        expectClose(convolve(A, Matrix([[2.0]])), Matrix([
            [2.0, 4.0, 6.0, 8.0, 10.0],
            [12.0, 14.0, 16.0, 18.0, 20.0],
            [22.0, 24.0, 26.0, 28.0, 30.0],
            [32.0, 34.0, 36.0, 38.0, 40.0]]))
    }

    // Exit tests only exist on macOS and Linux.
    #if os(macOS) || os(Linux)
    @Test("kernel with even rows is rejected", .exitTests)
    func evenRows() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            let K = Matrix(2, 3, 1.0)
            let A = Matrix(4, 5, 1.0)
            _ = convolve(A, K)
        }
        let stderr = String(decoding: result?.standardErrorContent ?? [], as: UTF8.self)
        #expect(stderr.contains("odd"), "stderr was: \(stderr)")
    }

    @Test("kernel with even columns is rejected", .exitTests)
    func evenColumns() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            let K = Matrix(3, 2, 1.0)
            let A = Matrix(4, 5, 1.0)
            _ = convolve(A, K)
        }
        let stderr = String(decoding: result?.standardErrorContent ?? [], as: UTF8.self)
        #expect(stderr.contains("odd"), "stderr was: \(stderr)")
    }

    @Test("kernel with even both is rejected", .exitTests)
    func evenBoth() async {
        let result = await #expect(processExitsWith: .failure, observing: [\.standardErrorContent]) {
            let K = Matrix(2, 2, 1.0)
            let A = Matrix(4, 5, 1.0)
            _ = convolve(A, K)
        }
        let stderr = String(decoding: result?.standardErrorContent ?? [], as: UTF8.self)
        #expect(stderr.contains("odd"), "stderr was: \(stderr)")
    }
    #endif
}
