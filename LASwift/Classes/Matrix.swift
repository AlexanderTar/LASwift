//
//  Matrix.swift
//  Pods
//
//  Created by Alexander Taraymovich on 28/02/2017.
//
//

public func zeros<T>(_ rows: Int, _ cols: Int) -> Matrix<T>
    where T: FloatingPoint, T: ExpressibleByFloatLiteral {
        return Matrix<T>(rows, cols, 0.0)
}

public func ones<T>(_ rows: Int, _ cols: Int) -> Matrix<T>
    where T: FloatingPoint, T: ExpressibleByFloatLiteral {
        return Matrix<T>(rows, cols, 1.0)
}

public func rand<T>(_ rows: Int, _ cols: Int) -> Matrix<T>
    where T: FloatingPoint, T: ExpressibleByFloatLiteral {
        return Matrix<T>((1...rows).map{ _ in (1...cols).map { _ in Random.generate() } })
}

public class Matrix<T> where T: FloatingPoint, T: ExpressibleByFloatLiteral {
    fileprivate var flat = [T]()
    fileprivate var rows: Int = 0
    fileprivate var cols: Int = 0
    
    public init(_ r: Int, _ c: Int, _ value: T = 0.0) {
        flat = [T](repeating: value, count: r * c)
        rows = r
        cols = c
    }
    
    public init(_ data: [[T]]) {
        // assuming empty input as invalid
        precondition(data.count > 0)
        precondition(data[0].count > 0)
        // check if all subarrays have same length
        precondition(Set(data.map { $0.count }).count == 1)
        
        flat = data.flatMap { $0 }
        rows = data.count
        cols = data[0].count
    }
    
    public subscript(_ row: Int, _ col: Int) -> T {
        get {
            assert(indexIsValidForRow(row, col))
            return flat[(row * cols) + col]
        }
        
        set {
            assert(indexIsValidForRow(row, col))
            flat[(row * cols) + col] = newValue
        }
    }
    
    public subscript(row row: Int) -> [T] {
        get {
            assert(row < rows)
            let startIndex = row * cols
            let endIndex = row * cols + cols
            return Array(flat[startIndex..<endIndex])
        }
        
        set {
            assert(row < rows)
            assert(newValue.count == cols)
            let startIndex = row * cols
            let endIndex = row * cols + cols
            flat.replaceSubrange(startIndex..<endIndex, with: newValue)
        }
    }
    
    public subscript(col col: Int) -> [T] {
        get {
            var result = [T](repeating: 0.0, count: rows)
            for i in 0..<rows {
                let index = i * cols + col
                result[i] = flat[index]
            }
            return result
        }
        
        set {
            assert(col < cols)
            assert(newValue.count == rows)
            for i in 0..<rows {
                let index = i * cols + col
                flat[index] = newValue[i]
            }
        }
    }
    
    fileprivate func indexIsValidForRow(_ row: Int, _ col: Int) -> Bool {
        return row >= 0 && row < rows && col >= 0 && col < cols
    }
}

// MARK: - Printable
extension Matrix: CustomStringConvertible {
    public var description: String {
        return "\((0..<rows).map{"\(self[row: $0])"}.joined(separator: "\n"))"
    }
}
