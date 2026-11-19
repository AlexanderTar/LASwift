//
//  Helpers.swift
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

// Test-side comparison helpers. Tests compare vectors and matrices through these,
// never through the library's own `==`, so the checks keep their meaning when the
// library's comparison operators change.

/// Absolute tolerance the old `==` on vectors and matrices used (Nimble's `==`).
let equalTolerance = 1e-14

/// Absolute tolerance of Nimble's default `beCloseTo`.
let closeTolerance = 1e-4

func isClose(_ a: Double, _ b: Double, tol: Double = equalTolerance) -> Bool {
    abs(a - b) <= tol
}

func isClose(_ a: Vector, _ b: Vector, tol: Double = equalTolerance) -> Bool {
    a.count == b.count && zip(a, b).allSatisfy { isClose($0, $1, tol: tol) }
}

func isClose(_ a: Matrix, _ b: Matrix, tol: Double = equalTolerance) -> Bool {
    a.rows == b.rows && a.cols == b.cols && isClose(a.flat, b.flat, tol: tol)
}

func expectClose(
    _ actual: Double, _ expected: Double, tol: Double = equalTolerance,
    sourceLocation: SourceLocation = #_sourceLocation
) {
    #expect(isClose(actual, expected, tol: tol), "\(actual) is not within \(tol) of \(expected)",
            sourceLocation: sourceLocation)
}

func expectClose(
    _ actual: Vector, _ expected: Vector, tol: Double = equalTolerance,
    sourceLocation: SourceLocation = #_sourceLocation
) {
    #expect(isClose(actual, expected, tol: tol), "\(actual) is not within \(tol) of \(expected)",
            sourceLocation: sourceLocation)
}

func expectClose(
    _ actual: Matrix, _ expected: Matrix, tol: Double = equalTolerance,
    sourceLocation: SourceLocation = #_sourceLocation
) {
    #expect(isClose(actual, expected, tol: tol),
            "\(actual.rows)x\(actual.cols) matrix\n\(actual)\nis not within \(tol) of \(expected.rows)x\(expected.cols) matrix\n\(expected)",
            sourceLocation: sourceLocation)
}
