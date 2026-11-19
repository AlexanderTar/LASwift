// PortableAccelerate.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

// Portable stand-ins for the vDSP and vForce routines LASwift calls, used where Accelerate
// is unavailable (Linux). Each one keeps Accelerate's C signature and semantics (operand
// order, strides, 1-based gather indices, index-in-array-units) so the call sites stay the
// same on every platform. On Apple platforms this file compiles to nothing.

#if !canImport(Accelerate)

import CLASwiftLAPACK

#if canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#endif

typealias vDSP_Length = UInt
typealias vDSP_Stride = Int

// MARK: - Vector-vector

func vDSP_vaddD(_ a: UnsafePointer<Double>, _ ia: vDSP_Stride, _ b: UnsafePointer<Double>, _ ib: vDSP_Stride,
                _ c: UnsafeMutablePointer<Double>, _ ic: vDSP_Stride, _ n: vDSP_Length) {
    for i in 0..<Int(n) { c[i * ic] = a[i * ia] + b[i * ib] }
}

/// C = A - B, with B passed first (as in Accelerate).
func vDSP_vsubD(_ b: UnsafePointer<Double>, _ ib: vDSP_Stride, _ a: UnsafePointer<Double>, _ ia: vDSP_Stride,
                _ c: UnsafeMutablePointer<Double>, _ ic: vDSP_Stride, _ n: vDSP_Length) {
    for i in 0..<Int(n) { c[i * ic] = a[i * ia] - b[i * ib] }
}

func vDSP_vmulD(_ a: UnsafePointer<Double>, _ ia: vDSP_Stride, _ b: UnsafePointer<Double>, _ ib: vDSP_Stride,
                _ c: UnsafeMutablePointer<Double>, _ ic: vDSP_Stride, _ n: vDSP_Length) {
    for i in 0..<Int(n) { c[i * ic] = a[i * ia] * b[i * ib] }
}

/// C = A / B, with B passed first (as in Accelerate).
func vDSP_vdivD(_ b: UnsafePointer<Double>, _ ib: vDSP_Stride, _ a: UnsafePointer<Double>, _ ia: vDSP_Stride,
                _ c: UnsafeMutablePointer<Double>, _ ic: vDSP_Stride, _ n: vDSP_Length) {
    for i in 0..<Int(n) { c[i * ic] = a[i * ia] / b[i * ib] }
}

func vDSP_dotprD(_ a: UnsafePointer<Double>, _ ia: vDSP_Stride, _ b: UnsafePointer<Double>, _ ib: vDSP_Stride,
                 _ c: UnsafeMutablePointer<Double>, _ n: vDSP_Length) {
    var s = 0.0
    for i in 0..<Int(n) { s += a[i * ia] * b[i * ib] }
    c.pointee = s
}

// MARK: - Vector-scalar

func vDSP_vsaddD(_ a: UnsafePointer<Double>, _ ia: vDSP_Stride, _ b: UnsafePointer<Double>,
                 _ c: UnsafeMutablePointer<Double>, _ ic: vDSP_Stride, _ n: vDSP_Length) {
    for i in 0..<Int(n) { c[i * ic] = a[i * ia] + b.pointee }
}

func vDSP_vsmulD(_ a: UnsafePointer<Double>, _ ia: vDSP_Stride, _ b: UnsafePointer<Double>,
                 _ c: UnsafeMutablePointer<Double>, _ ic: vDSP_Stride, _ n: vDSP_Length) {
    for i in 0..<Int(n) { c[i * ic] = a[i * ia] * b.pointee }
}

func vDSP_vsdivD(_ a: UnsafePointer<Double>, _ ia: vDSP_Stride, _ b: UnsafePointer<Double>,
                 _ c: UnsafeMutablePointer<Double>, _ ic: vDSP_Stride, _ n: vDSP_Length) {
    for i in 0..<Int(n) { c[i * ic] = a[i * ia] / b.pointee }
}

/// Elements below the threshold become 0; the rest (including NaN) are kept.
func vDSP_vthresD(_ a: UnsafePointer<Double>, _ ia: vDSP_Stride, _ t: UnsafePointer<Double>,
                  _ c: UnsafeMutablePointer<Double>, _ ic: vDSP_Stride, _ n: vDSP_Length) {
    for i in 0..<Int(n) { let v = a[i * ia]; c[i * ic] = v < t.pointee ? 0 : v }
}

// MARK: - Unary

func vDSP_vabsD(_ a: UnsafePointer<Double>, _ ia: vDSP_Stride, _ c: UnsafeMutablePointer<Double>,
                _ ic: vDSP_Stride, _ n: vDSP_Length) {
    for i in 0..<Int(n) { c[i * ic] = Swift.abs(a[i * ia]) }
}

func vDSP_vnegD(_ a: UnsafePointer<Double>, _ ia: vDSP_Stride, _ c: UnsafeMutablePointer<Double>,
                _ ic: vDSP_Stride, _ n: vDSP_Length) {
    for i in 0..<Int(n) { c[i * ic] = -a[i * ia] }
}

func vDSP_vsqD(_ a: UnsafePointer<Double>, _ ia: vDSP_Stride, _ c: UnsafeMutablePointer<Double>,
               _ ic: vDSP_Stride, _ n: vDSP_Length) {
    for i in 0..<Int(n) { c[i * ic] = a[i * ia] * a[i * ia] }
}

// MARK: - Reductions

func vDSP_sveD(_ a: UnsafePointer<Double>, _ ia: vDSP_Stride, _ c: UnsafeMutablePointer<Double>, _ n: vDSP_Length) {
    var s = 0.0
    for i in 0..<Int(n) { s += a[i * ia] }
    c.pointee = s
}

func vDSP_svesqD(_ a: UnsafePointer<Double>, _ ia: vDSP_Stride, _ c: UnsafeMutablePointer<Double>, _ n: vDSP_Length) {
    var s = 0.0
    for i in 0..<Int(n) { s += a[i * ia] * a[i * ia] }
    c.pointee = s
}

func vDSP_meanvD(_ a: UnsafePointer<Double>, _ ia: vDSP_Stride, _ c: UnsafeMutablePointer<Double>, _ n: vDSP_Length) {
    var s = 0.0
    vDSP_sveD(a, ia, &s, n)
    c.pointee = n == 0 ? .nan : s / Double(n)
}

/// Largest non-NaN element; NaN when every element is NaN (as Accelerate returns).
func vDSP_maxvD(_ a: UnsafePointer<Double>, _ ia: vDSP_Stride, _ c: UnsafeMutablePointer<Double>, _ n: vDSP_Length) {
    var m = Double.nan
    for i in 0..<Int(n) where m.isNaN || a[i * ia] > m { m = a[i * ia] }
    c.pointee = m
}

/// Smallest non-NaN element; NaN when every element is NaN (as Accelerate returns).
func vDSP_minvD(_ a: UnsafePointer<Double>, _ ia: vDSP_Stride, _ c: UnsafeMutablePointer<Double>, _ n: vDSP_Length) {
    var m = Double.nan
    for i in 0..<Int(n) where m.isNaN || a[i * ia] < m { m = a[i * ia] }
    c.pointee = m
}

/// The index is in units of the underlying array (element index * stride), as in Accelerate.
func vDSP_maxviD(_ a: UnsafePointer<Double>, _ ia: vDSP_Stride, _ c: UnsafeMutablePointer<Double>,
                 _ idx: UnsafeMutablePointer<vDSP_Length>, _ n: vDSP_Length) {
    var m = -Double.infinity, k = 0
    for i in 0..<Int(n) where a[i * ia] > m { m = a[i * ia]; k = i }
    c.pointee = m; idx.pointee = vDSP_Length(k * ia)
}

func vDSP_minviD(_ a: UnsafePointer<Double>, _ ia: vDSP_Stride, _ c: UnsafeMutablePointer<Double>,
                 _ idx: UnsafeMutablePointer<vDSP_Length>, _ n: vDSP_Length) {
    var m = Double.infinity, k = 0
    for i in 0..<Int(n) where a[i * ia] < m { m = a[i * ia]; k = i }
    c.pointee = m; idx.pointee = vDSP_Length(k * ia)
}

/// Mean, population standard deviation, and C = (A - mean) / deviation.
/// With NaN or infinite input the deviation is NaN here, where Accelerate reports 0;
/// `std` documents that difference.
func vDSP_normalizeD(_ a: UnsafePointer<Double>, _ ia: vDSP_Stride, _ c: UnsafeMutablePointer<Double>?,
                     _ ic: vDSP_Stride, _ mean: UnsafeMutablePointer<Double>, _ sd: UnsafeMutablePointer<Double>,
                     _ n: vDSP_Length) {
    var m = 0.0
    vDSP_meanvD(a, ia, &m, n)
    var v = 0.0
    for i in 0..<Int(n) { let d = a[i * ia] - m; v += d * d }
    let s = (v / Double(n)).squareRoot()
    mean.pointee = m; sd.pointee = s
    if let c { for i in 0..<Int(n) { c[i * ic] = (a[i * ia] - m) / s } }
}

// MARK: - Gather and matrix moves

/// C[i] = A[B[i] - 1]: gather with 1-based indices, as in Accelerate.
func vDSP_vgathrD(_ a: UnsafePointer<Double>, _ b: UnsafePointer<vDSP_Length>, _ ib: vDSP_Stride,
                  _ c: UnsafeMutablePointer<Double>, _ ic: vDSP_Stride, _ n: vDSP_Length) {
    for i in 0..<Int(n) { c[i * ic] = a[Int(b[i * ib]) - 1] }
}

/// Copy an n-row by m-column submatrix from A (ta columns) to C (tc columns).
func vDSP_mmovD(_ a: UnsafePointer<Double>, _ c: UnsafeMutablePointer<Double>, _ m: vDSP_Length,
                _ n: vDSP_Length, _ ta: vDSP_Length, _ tc: vDSP_Length) {
    for r in 0..<Int(n) {
        for col in 0..<Int(m) { c[r * Int(tc) + col] = a[r * Int(ta) + col] }
    }
}

/// C (m x n) = transpose of A (n x m).
func vDSP_mtransD(_ a: UnsafePointer<Double>, _ ia: vDSP_Stride, _ c: UnsafeMutablePointer<Double>,
                  _ ic: vDSP_Stride, _ m: vDSP_Length, _ n: vDSP_Length) {
    let m = Int(m), n = Int(n)
    for i in 0..<m {
        for j in 0..<n { c[(i * n + j) * ic] = a[(j * m + i) * ia] }
    }
}

/// C (m x n) = A (m x p) * B (p x n), through BLAS dgemm for unit strides.
func vDSP_mmulD(_ a: UnsafePointer<Double>, _ ia: vDSP_Stride, _ b: UnsafePointer<Double>, _ ib: vDSP_Stride,
                _ c: UnsafeMutablePointer<Double>, _ ic: vDSP_Stride, _ m: vDSP_Length, _ n: vDSP_Length,
                _ p: vDSP_Length) {
    let m = Int(m), n = Int(n), p = Int(p)
    if ia == 1 && ib == 1 && ic == 1 {
        if m > 0 && n > 0 && p > 0 {
            laswift_cblas_dgemm_rowmajor(m, n, p, a, b, c)
        } else {
            for i in 0..<(m * n) { c[i] = 0 }
        }
        return
    }
    for i in 0..<m {
        for j in 0..<n { c[(i * n + j) * ic] = 0 }
        for k in 0..<p {
            let aik = a[(i * p + k) * ia]
            for j in 0..<n { c[(i * n + j) * ic] += aik * b[(k * n + j) * ib] }
        }
    }
}

// MARK: - vForce

private func map(_ y: UnsafeMutablePointer<Double>, _ x: UnsafePointer<Double>, _ n: UnsafePointer<Int32>,
                 _ f: (Double) -> Double) {
    for i in 0..<Int(n.pointee) { y[i] = f(x[i]) }
}

func vvsqrt(_ y: UnsafeMutablePointer<Double>, _ x: UnsafePointer<Double>, _ n: UnsafePointer<Int32>) { map(y, x, n, sqrt) }
func vvexp(_ y: UnsafeMutablePointer<Double>, _ x: UnsafePointer<Double>, _ n: UnsafePointer<Int32>) { map(y, x, n, exp) }
func vvlog(_ y: UnsafeMutablePointer<Double>, _ x: UnsafePointer<Double>, _ n: UnsafePointer<Int32>) { map(y, x, n, log) }
func vvlog2(_ y: UnsafeMutablePointer<Double>, _ x: UnsafePointer<Double>, _ n: UnsafePointer<Int32>) { map(y, x, n, log2) }
func vvlog10(_ y: UnsafeMutablePointer<Double>, _ x: UnsafePointer<Double>, _ n: UnsafePointer<Int32>) { map(y, x, n, log10) }
func vvsin(_ y: UnsafeMutablePointer<Double>, _ x: UnsafePointer<Double>, _ n: UnsafePointer<Int32>) { map(y, x, n, sin) }
func vvcos(_ y: UnsafeMutablePointer<Double>, _ x: UnsafePointer<Double>, _ n: UnsafePointer<Int32>) { map(y, x, n, cos) }
func vvtan(_ y: UnsafeMutablePointer<Double>, _ x: UnsafePointer<Double>, _ n: UnsafePointer<Int32>) { map(y, x, n, tan) }
func vvasin(_ y: UnsafeMutablePointer<Double>, _ x: UnsafePointer<Double>, _ n: UnsafePointer<Int32>) { map(y, x, n, asin) }
func vvacos(_ y: UnsafeMutablePointer<Double>, _ x: UnsafePointer<Double>, _ n: UnsafePointer<Int32>) { map(y, x, n, acos) }
func vvatan(_ y: UnsafeMutablePointer<Double>, _ x: UnsafePointer<Double>, _ n: UnsafePointer<Int32>) { map(y, x, n, atan) }

/// z[i] = x[i] raised to the scalar exponent y.
func vvpows(_ z: UnsafeMutablePointer<Double>, _ y: UnsafePointer<Double>, _ x: UnsafePointer<Double>,
            _ n: UnsafePointer<Int32>) {
    for i in 0..<Int(n.pointee) { z[i] = pow(x[i], y.pointee) }
}

// MARK: - 2-D correlation (vDSP.convolve)

enum vDSP {
    /// Correlate `x` (rows x cols) with `k` (kr x kc); like Accelerate, the border of half a
    /// kernel is left 0 and only the interior is computed.
    static func convolve(_ x: [Double], rowCount: Int, columnCount: Int, withKernel k: [Double],
                         kernelRowCount kr: Int, kernelColumnCount kc: Int) -> [Double] {
        var out = [Double](repeating: 0, count: x.count)
        let hr = kr / 2, hc = kc / 2
        guard rowCount > 2 * hr, columnCount > 2 * hc else { return out }
        for r in hr..<(rowCount - hr) {
            for c in hc..<(columnCount - hc) {
                var s = 0.0
                for i in 0..<kr {
                    for j in 0..<kc { s += x[(r - hr + i) * columnCount + (c - hc + j)] * k[i * kc + j] }
                }
                out[r * columnCount + c] = s
            }
        }
        return out
    }

    static func convolve(_ x: [Double], rowCount: Int, columnCount: Int, with3x3Kernel k: [Double]) -> [Double] {
        convolve(x, rowCount: rowCount, columnCount: columnCount, withKernel: k, kernelRowCount: 3, kernelColumnCount: 3)
    }
}

#endif
