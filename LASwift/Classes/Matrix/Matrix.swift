//
//  Matrix.swift
//  Pods
//
//  Created by Alexander Taraymovich on 28/02/2017.
//
//

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
    return Matrix((0..<rows).map{ _ in rand(cols) })
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
    let count = v.rows
    var m: Matrix = zeros(count, count)
    for i in 0..<count {
        m[i, i] = v[i, 0]
    }
    return m
}

public func diag(_ v: Vector) -> Matrix {
    let count = v.count
    var m: Matrix = zeros(count, count)
    for i in 0..<count {
        m[i, i] = v[i]
    }
    return m
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
            for i in 0..<rows {
                let index = i * cols + col
                result[i] = flat[index]
            }
            return result
        }
        
        set {
            precondition(col < cols, "Invalid index")
            precondition(newValue.count == rows, "Input dimensions must agree")
            for i in 0..<rows {
                let index = i * cols + col
                flat[index] = newValue[i]
            }
        }
    }
    
    internal func indexIsValidForRow(_ row: Int, _ col: Int) -> Bool {
        return row >= 0 && row < rows && col >= 0 && col < cols
    }
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
