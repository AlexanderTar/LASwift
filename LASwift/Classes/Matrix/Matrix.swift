// Matrix.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

import Accelerate

// MARK: - One-line creators for matrices

public func zeros(_ rows: Int, _ cols: Int) -> Matrix {
    precondition(rows > 0 && cols > 0, "Matrix dimensions must be positive")
    return Matrix(rows, cols, 0.0)
}

public func ones(_ rows: Int, _ cols: Int) -> Matrix {
    precondition(rows > 0 && cols > 0, "Matrix dimensions must be positive")
    return Matrix(rows, cols, 1.0)
}

public func rand(_ rows: Int, _ cols: Int) -> Matrix {
    precondition(rows > 0 && cols > 0, "Matrix dimensions must be positive")
    return Matrix(rows, cols, rand(rows * cols))
}

public func eye(_ rows: Int, _ cols: Int) -> Matrix {
    precondition(rows > 0 && cols > 0, "Matrix dimensions must be positive")
    return Matrix((0..<rows).map { (i: Int) -> Vector in
        var row = Vector(repeating: 0.0, count: cols)
        if (i < cols) {
            row[i] = 1.0
        }
        return row
    })
}

public func diag(_ v: Matrix) -> Matrix {
    precondition(v.cols == 1, "Input must be a vector")
    return diag(v.flat)
}

public func diag(_ v: Vector) -> Matrix {
    let count = v.count
    var m: Matrix = zeros(count, count)
    (0..<count).map { m[$0, $0] = v[$0] }
    return m
}

public func diag(_ rows: Int, _ cols: Int, _ v: Matrix) -> Matrix {
    precondition(v.cols == 1, "Input must be a vector")
    return diag(rows, cols, v.flat)
}

public func diag(_ rows: Int, _ cols: Int, _ v: Vector) -> Matrix {
    precondition(rows > 0 && cols > 0, "Matrix dimensions must be positive")
    return Matrix((0..<rows).map { (i: Int) -> Vector in
        var row = Vector(repeating: 0.0, count: cols)
        if (i < cols) {
            row[i] = v[i]
        }
        return row
    })
}

// MARK: - Matrix class

public class Matrix {
    internal var flat = Vector()
    internal var _rows: Int = 0
    internal var _cols: Int = 0
    
    public var rows: Int {
        return _rows
    }
    
    public var cols: Int {
        return _cols
    }
    
    internal init(_ r: Int, _ c: Int, _ value: Double = 0.0) {
        precondition(r > 0 && c > 0, "Matrix dimensions must be positive")
        flat = Vector(repeating: value, count: r * c)
        _rows = r
        _cols = c
    }
    
    internal init(_ r: Int, _ c: Int, _ f: Vector) {
        precondition(r * c == f.count, "Matrix dimensions must agree")
        flat = f
        _rows = r
        _cols = c
    }
    
    public init(_ M: Matrix) {
        flat = M.flat
        _rows = M.rows
        _cols = M.cols
    }
    
    public init(_ v: Vector) {
        flat = v
        _rows = v.count
        _cols = 1
    }
    
    public init(_ data: [Vector]) {
        // assuming empty input as invalid
        precondition(data.count > 0, "Input must not be empty")
        precondition(data[0].count > 0, "Input must not be empty")
        // check if all subarrays have same length
        precondition(Set(data.map { $0.count }).count == 1, "Input dimensions must agree")
        
        flat = data.flatMap { $0 }
        _rows = data.count
        _cols = data[0].count
    }
}

// MARK: - Gathering

extension Matrix {
    public subscript(_ row: Int, _ col: Int ) -> Double {
        get {
            precondition(indexIsValidForRow(row, col), "Invalid index")
            return flat[(row * cols) + col]
        }
        
        set {
            precondition(indexIsValidForRow(row, col), "Invalid index")
            flat[(row * cols) + col] = newValue
        }
    }
    
    public subscript(_ index: Int) -> Double {
        get {
            precondition(index < rows * cols, "Invalid index")
            return flat[index]
        }
        
        set {
            precondition(index < rows * cols, "Invalid index")
            flat[index] = newValue
        }
    }
    
    public subscript(row row: Int) -> Vector {
        get {
            precondition(row < rows, "Invalid index")
            let startIndex = row * cols
            let endIndex = row * cols + cols
            return Array(flat[startIndex..<endIndex])
        }
        
        set {
            precondition(row < rows, "Invalid index")
            precondition(newValue.count == cols, "Input dimensions must agree")
            let startIndex = row * cols
            let endIndex = row * cols + cols
            flat.replaceSubrange(startIndex..<endIndex, with: newValue)
        }
    }
    
    public subscript(col col: Int) -> Vector {
        get {
            precondition(col < cols, "Invalid index")
            var result = Vector(repeating: 0.0, count: rows)
            (0..<rows).map { i -> () in
                let index = i * cols + col
                result[i] = flat[index]
            }
            return result
        }
        
        set {
            precondition(col < cols, "Invalid index")
            precondition(newValue.count == rows, "Input dimensions must agree")
            (0..<rows).map { i -> () in
                let index = i * cols + col
                flat[index] = newValue[i]
            }
        }
    }
    
    internal func indexIsValidForRow(_ row: Int, _ col: Int) -> Bool {
        return row >= 0 && row < rows && col >= 0 && col < cols
    }
}

// MARK: - Matrix manipulation

public func insert(_ m: Matrix, row row: Vector, at index: Int) -> Matrix {
    return insert(m, rows: Matrix([row]), at: index)
}

public func insert(_ m: Matrix, rows rows: Matrix, at index: Int) -> Matrix {
    precondition(rows.cols == m.cols, "Input dimensions must agree")
    precondition(index <= m.rows, "Index out of bounds")
    
    let res = zeros(m.rows + rows.rows, m.cols)
    
    if (index > 0) {
        vDSP_mmovD(m.flat, &res.flat, vDSP_Length(m.cols), vDSP_Length(index), vDSP_Length(m.cols), vDSP_Length(res.cols))
    }
    
    vDSP_mmovD(rows.flat, &res.flat[index * res.cols], vDSP_Length(m.cols), vDSP_Length(rows.rows), vDSP_Length(m.cols), vDSP_Length(res.cols))
    
    if (index < m.rows) {
        m.flat.withUnsafeBufferPointer { bufPtr in
            let p = bufPtr.baseAddress! + index * m.cols
            vDSP_mmovD(p, &res.flat[(index + rows.rows) * res.cols], vDSP_Length(m.cols), vDSP_Length(m.rows - index), vDSP_Length(m.cols), vDSP_Length(res.cols))
        }
    }
    
    return res
}

public func append(_ m: Matrix, row row: Matrix) -> Matrix {
    precondition(row.cols == m.cols && row.rows == 1, "Input dimensions must agree")
    return insert(m, row: row.flat, at: m.rows)
}

public func append(_ m: Matrix, row row: Vector) -> Matrix {
    let r = Matrix([row])
    return append(m, row: r)
}

public func append(_ m: Matrix, row row: Double) -> Matrix {
    let r = Vector(repeating: row, count: m.cols)
    return append(m, row: r)
}

public func append(_ m: Matrix, rows rows: Matrix) -> Matrix {
    return insert(m, rows: rows, at: m.rows)
}

public func append(_ m: Matrix, rows rows: [Vector]) -> Matrix {
    return append(m, rows: Matrix(rows))
}

public func === (_ m: Matrix, _ row: Double) -> Matrix {
    return append(m, row: row)
}

public func === (_ m: Matrix, _ row: Vector) -> Matrix {
    return append(m, row: row)
}

public func prepend(_ m: Matrix, row row: Matrix) -> Matrix {
    precondition(row.cols == m.cols && row.rows == 1, "Input dimensions must agree")
    return insert(m, row: row.flat, at: 0)
}

public func prepend(_ m: Matrix, row row: Vector) -> Matrix {
    let r = Matrix([row])
    return prepend(m, row: r)
}

public func prepend(_ m: Matrix, row row: Double) -> Matrix {
    let r = Vector(repeating: row, count: m.cols)
    return prepend(m, row: r)
}

public func prepend(_ m: Matrix, rows rows: Matrix) -> Matrix {
    return insert(m, rows: rows, at: 0)
}

public func prepend(_ m: Matrix, rows rows: [Vector]) -> Matrix {
    return prepend(m, rows: Matrix(rows))
}

public func === (_ row: Double, _ m: Matrix) -> Matrix {
    return prepend(m, row: row)
}

public func === (_ row: Vector, _ m: Matrix) -> Matrix {
    return prepend(m, row: row)
}

public func === (_ lhs: Matrix, _ rhs: Matrix) -> Matrix {
    return append(lhs, rows: rhs)
}

public func insert(_ m: Matrix, col col: Vector, at index: Int) -> Matrix {
    return insert(m, cols: Matrix(col), at: index)
}

public func insert(_ m: Matrix, cols cols: Matrix, at index: Int) -> Matrix {
    precondition(cols.rows == m.rows, "Input dimensions must agree")
    precondition(index <= m.cols && index >= 0, "Index out of bounds")
    
    let res = zeros(m.rows, m.cols + cols.cols)
    
    if (index > 0) {
        vDSP_mmovD(m.flat, &res.flat, vDSP_Length(index), vDSP_Length(m.rows), vDSP_Length(m.cols), vDSP_Length(res.cols))
    }
    
    vDSP_mmovD(cols.flat, &res.flat[index], vDSP_Length(cols.cols), vDSP_Length(m.rows), vDSP_Length(cols.cols), vDSP_Length(res.cols))
    
    if (index < m.cols) {
        m.flat.withUnsafeBufferPointer { bufPtr in
            let p = bufPtr.baseAddress! + index
            vDSP_mmovD(p, &res.flat[index + cols.cols], vDSP_Length(m.cols - index), vDSP_Length(m.rows), vDSP_Length(m.cols), vDSP_Length(res.cols))
        }
    }
    
    return res
}

public func append(_ m: Matrix, col col: Matrix) -> Matrix {
    precondition(col.rows == m.rows && col.cols == 1, "Input dimensions must agree")
    return insert(m, col: col.flat, at: m.cols)
}

public func append(_ m: Matrix, col col: Vector) -> Matrix {
    let c = Matrix(col.count, 1, col)
    return append(m, col: c)
}

public func append(_ m: Matrix, col col: Double) -> Matrix {
    let c = Vector(repeating: col, count: m.rows)
    return append(m, col: c)
}

public func append(_ m: Matrix, cols cols: Matrix) -> Matrix {
    return insert(m, cols: cols, at: m.cols)
}

public func append(_ m: Matrix, cols cols: [Vector]) -> Matrix {
    return append(m, cols: Matrix(cols))
}

public func ||| (_ m: Matrix, _ col: Double) -> Matrix {
    return append(m, col: col)
}

public func ||| (_ m: Matrix, _ col: Vector) -> Matrix {
    return append(m, col: col)
}

public func prepend(_ m: Matrix, col col: Matrix) -> Matrix {
    precondition(col.rows == m.rows && col.cols == 1, "Input dimensions must agree")
    return insert(m, col: col.flat, at: 0)
}

public func prepend(_ m: Matrix, col col: Vector) -> Matrix {
    let c = Matrix(col)
    return prepend(m, col: c)
}

public func prepend(_ m: Matrix, col col: Double) -> Matrix {
    let c = Vector(repeating: col, count: m.rows)
    return prepend(m, col: c)
}

public func prepend(_ m: Matrix, cols cols: Matrix) -> Matrix {
    return insert(m, cols: cols, at: 0)
}

public func prepend(_ m: Matrix, cols cols: [Vector]) -> Matrix {
    return prepend(m, cols: transpose(Matrix(cols)))
}

public func ||| (_ col: Double, _ m: Matrix) -> Matrix {
    return prepend(m, col: col)
}

public func ||| (_ col: Vector, _ m: Matrix) -> Matrix {
    return prepend(m, col: col)
}

public func ||| (_ lhs: Matrix, _ rhs: Matrix) -> Matrix {
    return append(lhs, cols: rhs)
}

// MARK: - Sequence

extension Matrix: Sequence {
    public typealias MatrixIterator = AnyIterator<ArraySlice<Double>>
    public func makeIterator() -> MatrixIterator {
        let end = rows * cols
        var nextRowStart = 0
        
        return AnyIterator {
            if nextRowStart == end {
                return nil
            }
            
            let currentRowStart = nextRowStart
            nextRowStart += self.cols
            
            return self.flat[currentRowStart..<nextRowStart]
        }
    }
}

// MARK: - Printable

extension Matrix: CustomStringConvertible {
    public var description: String {
        return "\((0..<rows).map{"\(self[row: $0])"}.joined(separator: "\n"))"
    }
}

// MARK: - Equatable

extension Matrix: Equatable {}
public func == (lhs: Matrix, rhs: Matrix) -> Bool {
    return lhs.rows == rhs.rows && lhs.cols == rhs.cols && lhs.flat ==~ rhs.flat
}
