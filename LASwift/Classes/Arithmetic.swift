//
//  Arithmetic.swift
//  Pods
//
//  Created by Alexander Taraymovich on 23/02/2017.
//
//

import Accelerate

// MARK: - Arithmetic operations on two vectors

typealias VectorVectorOperation<T> = ((_: UnsafePointer<T>, _: vDSP_Stride, _: UnsafePointer<T>, _: vDSP_Stride, _: UnsafeMutablePointer<T>, _: vDSP_Stride, _: vDSP_Length) -> ())
where T: FloatingPoint, T: ExpressibleByFloatLiteral

func vectorOperation<T>(_ op: VectorVectorOperation<T>, _ a: [T], _ b: [T]) -> [T]
    where T: FloatingPoint, T: ExpressibleByFloatLiteral {
    precondition(a.count == b.count)
    var c = [T](repeating: 0.0, count: a.count)
    op(a, 1, b, 1, &c, 1, vDSP_Length(a.count))
    return c
}

public func add(_ a: [Double], _ b: [Double]) -> [Double] {
    return vectorOperation(vDSP_vaddD, a, b)
}

public func add(_ a: [Float], _ b: [Float]) -> [Float] {
    return vectorOperation(vDSP_vadd, a, b)
}

public func sub(_ a: [Double], _ b: [Double]) -> [Double] {
    return vectorOperation(vDSP_vsubD, b, a)
}

public func sub(_ a: [Float], _ b: [Float]) -> [Float] {
    return vectorOperation(vDSP_vsub, b, a)
}

public func mul(_ a: [Double], _ b: [Double]) -> [Double] {
    return vectorOperation(vDSP_vmulD, a, b)
}

public func mul(_ a: [Float], _ b: [Float]) -> [Float] {
    return vectorOperation(vDSP_vmul, a, b)
}

public func div(_ a: [Double], _ b: [Double]) -> [Double] {
    return vectorOperation(vDSP_vdivD, b, a)
}

public func div(_ a: [Float], _ b: [Float]) -> [Float] {
    return vectorOperation(vDSP_vdiv, b, a)
}

// MARK: - Dot product operations on two vectors

public func dot(_ a: [Double], _ b: [Double]) -> Double {
    precondition(a.count == b.count)
    var c: Double = 0.0
    vDSP_dotprD(a, 1, b, 1, &c, vDSP_Length(a.count))
    return c
}

public func dot(_ a: [Float], _ b: [Float]) -> Float {
    precondition(a.count == b.count)
    var c: Float = 0.0
    vDSP_dotpr(a, 1, b, 1, &c, vDSP_Length(a.count))
    return c
}

// MARK: - Arithmetic operations on vector and scalar

typealias VectorScalarOperation<T> = ((_: UnsafePointer<T>, _: vDSP_Stride, _: UnsafePointer<T>, _: UnsafeMutablePointer<T>, _: vDSP_Stride, _: vDSP_Length) -> ())
where T: FloatingPoint, T: ExpressibleByFloatLiteral

func scalarOperation<T>(_ op: VectorScalarOperation<T>, _ a: [T], _ b: T) -> [T]
    where T: FloatingPoint, T: ExpressibleByFloatLiteral {
    var c = [T](repeating: 0.0, count: a.count)
    var b = b
    op(a, 1, &b, &c, 1, vDSP_Length(a.count))
    return c
}

public func add(_ a: [Double], _ b: Double) -> [Double] {
    return scalarOperation(vDSP_vsaddD, a, b)
}

public func add(_ a: [Float], _ b: Float) -> [Float] {
    return scalarOperation(vDSP_vsadd, a, b)
}

public func sub(_ a: [Double], _ b: Double) -> [Double] {
    return scalarOperation(vDSP_vsaddD, a, -b)
}

public func sub(_ a: [Float], _ b: Float) -> [Float] {
    return scalarOperation(vDSP_vsadd, a, -b)
}

public func mul(_ a: [Double], _ b: Double) -> [Double] {
    return scalarOperation(vDSP_vsmulD, a, b)
}

public func mul(_ a: [Float], _ b: Float) -> [Float] {
    return scalarOperation(vDSP_vsmul, a, b)
}

public func div(_ a: [Double], _ b: Double) -> [Double] {
    return scalarOperation(vDSP_vsdivD, a, b)
}

public func div(_ a: [Float], _ b: Float) -> [Float] {
    return scalarOperation(vDSP_vsdiv, a, b)
}

// MARK: - Unary operations on vector

typealias UnaryScalarOperation<T> = ((_: UnsafePointer<T>, _: vDSP_Stride, _: UnsafeMutablePointer<T>, _: vDSP_Length) -> ())
where T: FloatingPoint, T: ExpressibleByFloatLiteral

func unaryOperation<T>(_ op: UnaryScalarOperation<T>, _ a: [T]) -> T {
    var c: T = 0.0 as! T
    op(a, 1, &c, vDSP_Length(a.count))
    return c
}

public func max(_ a: [Double]) -> Double {
    return unaryOperation(vDSP_maxvD, a)
}

public func max(_ a: [Float]) -> Float {
    return unaryOperation(vDSP_maxv, a)
}

public func min(_ a: [Double]) -> Double {
    return unaryOperation(vDSP_minvD, a)
}

public func min(_ a: [Float]) -> Float {
    return unaryOperation(vDSP_minv, a)
}

public func mean(_ a: [Double]) -> Double {
    return unaryOperation(vDSP_meanvD, a)
}

public func mean(_ a: [Float]) -> Float {
    return unaryOperation(vDSP_meanv, a)
}

public func std(_ a: [Double]) -> Double {
    var m: Double = 0.0
    var s: Double = 0.0
    var c = [Double](repeating: 0.0, count: a.count)
    vDSP_normalizeD(a, 1, &c, 1, &m, &s, vDSP_Length(a.count))
    return s
}

public func std(_ a: [Float]) -> Float {
    var m: Float = 0.0
    var s: Float = 0.0
    var c = [Float](repeating: 0.0, count: a.count)
    vDSP_normalize(a, 1, &c, 1, &m, &s, vDSP_Length(a.count))
    return s
}

typealias UnaryVectorOperation<T> = ((_: UnsafePointer<T>, _: vDSP_Stride, _: UnsafeMutablePointer<T>, _: vDSP_Stride, _: vDSP_Length) -> ())
where T: FloatingPoint, T: ExpressibleByFloatLiteral

func unaryOperation<T>(_ op: UnaryVectorOperation<T>, _ a: [T]) -> [T]
    where T: FloatingPoint, T: ExpressibleByFloatLiteral {
    var c = [T](repeating: 0.0, count: a.count)
    op(a, 1, &c, 1, vDSP_Length(a.count))
    return c
}

public func abs(_ a: [Double]) -> [Double] {
    return unaryOperation(vDSP_vabsD, a)
}

public func abs(_ a: [Float]) -> [Float] {
    return unaryOperation(vDSP_vabs, a)
}

public func neg(_ a: [Double]) -> [Double] {
    return unaryOperation(vDSP_vnegD, a)
}

public func neg(_ a: [Float]) -> [Float] {
    return unaryOperation(vDSP_vneg, a)
}

public func square(_ a: [Double]) -> [Double] {
    return unaryOperation(vDSP_vsqD, a)
}

public func square(_ a: [Float]) -> [Float] {
    return unaryOperation(vDSP_vsq, a)
}

public func norm(_ a: [Double]) -> [Double] {
    var m: Double = 0.0
    var s: Double = 0.0
    var c = [Double](repeating: 0.0, count: a.count)
    vDSP_normalizeD(a, 1, &c, 1, &m, &s, vDSP_Length(a.count))
    return c
}

public func norm(_ a: [Float]) -> [Float] {
    var m: Float = 0.0
    var s: Float = 0.0
    var c = [Float](repeating: 0.0, count: a.count)
    vDSP_normalize(a, 1, &c, 1, &m, &s, vDSP_Length(a.count))
    return c
}

typealias UnaryVectorFunction<T> = ((_: UnsafeMutablePointer<T>, _: UnsafePointer<T>, _: UnsafePointer<Int32>) -> ())
where T: FloatingPoint, T: ExpressibleByFloatLiteral

func unaryFunction<T>(_ op: UnaryVectorFunction<T>, _ a: [T]) -> [T]
    where T: FloatingPoint, T: ExpressibleByFloatLiteral {
        var c = [T](repeating: 0.0, count: a.count)
        var l = Int32(a.count)
        op(&c, a, &l)
        return c
}

public func sqrt(_ a: [Double]) -> [Double] {
    return unaryFunction(vvsqrt, a)
}

public func sqrt(_ a: [Float]) -> [Float] {
    return unaryFunction(vvsqrtf, a)
}

public func exp(_ a: [Double]) -> [Double] {
    return unaryFunction(vvexp, a)
}

public func exp(_ a: [Float]) -> [Float] {
    return unaryFunction(vvexpf, a)
}

public func log(_ a: [Double]) -> [Double] {
    return unaryFunction(vvlog, a)
}

public func log(_ a: [Float]) -> [Float] {
    return unaryFunction(vvlogf, a)
}

public func log2(_ a: [Double]) -> [Double] {
    return unaryFunction(vvlog2, a)
}

public func log2(_ a: [Float]) -> [Float] {
    return unaryFunction(vvlog2f, a)
}

public func log10(_ a: [Double]) -> [Double] {
    return unaryFunction(vvlog10, a)
}

public func log10(_ a: [Float]) -> [Float] {
    return unaryFunction(vvlog10f, a)
}

public func sin(_ a: [Double]) -> [Double] {
    return unaryFunction(vvsin, a)
}

public func sin(_ a: [Float]) -> [Float] {
    return unaryFunction(vvsinf, a)
}

public func cos(_ a: [Double]) -> [Double] {
    return unaryFunction(vvcos, a)
}

public func cos(_ a: [Float]) -> [Float] {
    return unaryFunction(vvcosf, a)
}

public func tan(_ a: [Double]) -> [Double] {
    return unaryFunction(vvtan, a)
}

public func tan(_ a: [Float]) -> [Float] {
    return unaryFunction(vvtanf, a)
}

public func pow(_ a: [Double], _ p: Double) -> [Double] {
    var c = [Double](repeating: 0.0, count: a.count)
    var l = Int32(a.count)
    var p = p
    vvpows(&c, &p, a, &l)
    return c
}

public func pow(_ a: [Float], _ p: Float) -> [Float] {
    var c = [Float](repeating: 0.0, count: a.count)
    var l = Int32(a.count)
    var p = p
    vvpowsf(&c, &p, a, &l)
    return c
}
