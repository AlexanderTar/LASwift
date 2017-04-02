// Matrix.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

import Accelerate

// MARK: - One-line creators for matrices

/// Create a matrix of zeros.
///
/// - Parameters:
///    - rows: number of rows
///    - cols: number of columns
/// - Returns: zeros matrix of specified size
public func zeros(_ rows: Int, _ cols: Int) -> Matrix {
    precondition(rows > 0 && cols > 0, "Matrix dimensions must be positive")
    return Matrix(rows, cols, 0.0)
}

/// Create a matrix of ones.
///
/// - Parameters:
///    - rows: number of rows
///    - cols: number of columns
/// - Returns: ones matrix of specified size
public func ones(_ rows: Int, _ cols: Int) -> Matrix {
    precondition(rows > 0 && cols > 0, "Matrix dimensions must be positive")
    return Matrix(rows, cols, 1.0)
}

/// Create a matrix of uniformly distributed on [0, 1) interval random values.
///
/// - Parameters:
///    - rows: number of rows
///    - cols: number of columns
/// - Returns: random values matrix of specified size
public func rand(_ rows: Int, _ cols: Int) -> Matrix {
    precondition(rows > 0 && cols > 0, "Matrix dimensions must be positive")
    return Matrix(rows, cols, rand(rows * cols))
}

/// Create a matrix of normally distibuted random values.
///
/// - Parameters:
///    - rows: number of rows
///    - cols: number of columns
/// - Returns: random values matrix of specified size
public func randn(_ rows: Int, _ cols: Int) -> Matrix {
    precondition(rows > 0 && cols > 0, "Matrix dimensions must be positive")
    return Matrix(rows, cols, randn(rows * cols))
}

/// Create a matrix with ones on the main diagonal and zeros elsewhere.
///
/// - Parameters:
///    - rows: number of rows
///    - cols: number of columns
/// - Returns: identity matrix of specified size
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

/// Create a square matrix with specified values on the main diagonal and zeros elsewhere.
///
/// - Parameters:
///    - v: matrix of values with one column
/// - Returns: square diagonal matrix with specified values
public func diag(_ v: Matrix) -> Matrix {
    precondition(v.cols == 1, "Input must be a vector")
    return diag(v.flat)
}

/// Create a square matrix with specified values on the main diagonal and zeros elsewhere.
///
/// - Parameters:
///    - v: vector of values
/// - Returns: square diagonal matrix with specified values
public func diag(_ v: Vector) -> Matrix {
    let count = v.count
    let m: Matrix = zeros(count, count)
    _ = (0..<count).map { m[$0, $0] = v[$0] }
    return m
}

/// Create a matrix with specified values on the main diagonal and zeros elsewhere.
///
/// - Parameters:
///    - rows: number of rows
///    - cols: number of columns
///    - v: matrix of values with one column
/// - Returns: diagonal matrix with specified values and size
public func diag(_ rows: Int, _ cols: Int, _ v: Matrix) -> Matrix {
    precondition(v.cols == 1, "Input must be a vector")
    return diag(rows, cols, v.flat)
}

/// Create a matrix with specified values on the main diagonal and zeros elsewhere.
///
/// - Parameters:
///    - rows: number of rows
///    - cols: number of columns
///    - v: vector of values
/// - Returns: diagonal matrix with specified values and size
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

/// Matrix dimensions.
///
/// - Row: row.
/// - Column: column.
public enum Dim {
    case Row
    case Column
}

/// Matrix of Double values
public class Matrix {
    internal var flat = Vector()
    internal var _rows: Int = 0
    internal var _cols: Int = 0
    
    /// Number of rows in Matrix.
    public var rows: Int {
        return _rows
    }
    
    /// Number of columns in Matrix.
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
    
    /// Create new Matrix by copying existing.
    public init(_ M: Matrix) {
        flat = M.flat
        _rows = M.rows
        _cols = M.cols
    }
    
    /// Create 1-column Matrix (transposed Vector)
    public init(_ v: Vector) {
        flat = v
        _rows = v.count
        _cols = 1
    }
    
    /// Create Matrix from array of Vectors (two-dimensional array)
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
    /// Get M(row, column) element of Matrix.
    ///
    /// - Parameters:
    ///    - row: row position of element (0-based)
    ///    - col: col position of element (0-based)
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
    
    /// Get M(index) element of row-major represented Matrix.
    ///
    /// - Parameters:
    ///    - index: index of element (0-based, 0 <= index < M.rows * M.cols)
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
    
    /// Get M(row) row of Matrix.
    ///
    /// - Parameters:
    ///    - row: row index (0-based)
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
    
    /// Get M(col) column of Matrix.
    ///
    /// - Parameters:
    ///    - col: column index (0-based)
    public subscript(col col: Int) -> Vector {
        get {
            precondition(col < cols, "Invalid index")
            var result = Vector(repeating: 0.0, count: rows)
            _ = (0..<rows).map { i -> () in
                let index = i * cols + col
                result[i] = flat[index]
            }
            return result
        }
        
        set {
            precondition(col < cols, "Invalid index")
            precondition(newValue.count == rows, "Input dimensions must agree")
            _ = (0..<rows).map { i -> () in
                let index = i * cols + col
                flat[index] = newValue[i]
            }
        }
    }
    
    /// Construct new matrix from source using specified extractor.
    ///
    /// Alternatively, `m[e]` can be executed with `m ?? e` or `slice(m, e)`
    ///
    /// - Parameters
    ///     - e: extractor tuple for rows and columns
    /// - Returns: extracted matrix
    public subscript(_ e: (er: Extractor, ec: Extractor)) -> Matrix {
        return slice(self, e)
    }
    
    internal func indexIsValidForRow(_ row: Int, _ col: Int) -> Bool {
        return row >= 0 && row < rows && col >= 0 && col < cols
    }
}

internal func toRows(_ A: Matrix, _ d: Dim) -> Matrix {
    switch d {
    case .Row:
        return A
    case .Column:
        return transpose(A)
    }
}

internal func toCols(_ A: Matrix, _ d: Dim) -> Matrix {
    switch d {
    case .Row:
        return transpose(A)
    case .Column:
        return A
    }
}

// MARK: - Matrix manipulation

/// Insert row to matrix at specified position.
///
/// - Parameters:
///    - m: matrix
///    - row: row values to insert
///    - at: index to insert row to
/// - Returns: new matrix with inserted row
public func insert(_ m: Matrix, row: Vector, at index: Int) -> Matrix {
    return insert(m, rows: Matrix([row]), at: index)
}

/// Insert rows to matrix at specified position.
///
/// - Parameters:
///    - m: matrix
///    - rows: rows values to insert represented as matrix
///    - at: index to insert rows to
/// - Returns: new matrix with inserted rows
public func insert(_ m: Matrix, rows: Matrix, at index: Int) -> Matrix {
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

/// Append row to matrix.
///
/// - Parameters:
///    - m: matrix
///    - row: row values to append represented as row matrix
/// - Returns: new matrix with appended row
public func append(_ m: Matrix, row: Matrix) -> Matrix {
    precondition(row.cols == m.cols && row.rows == 1, "Input dimensions must agree")
    return insert(m, row: row.flat, at: m.rows)
}

/// Append row to matrix.
///
/// Alternatively, `append(m, row: row)` can be executed with `m === row`.
///
/// - Parameters:
///    - m: matrix
///    - row: row values to append
/// - Returns: new matrix with appended row
public func append(_ m: Matrix, row: Vector) -> Matrix {
    let r = Matrix([row])
    return append(m, row: r)
}

/// Append row to matrix constructed from scalar value.
///
/// Alternatively, `append(m, row: row)` can be executed with `m === row`.
///
/// - Parameters:
///    - m: matrix
///    - row: row value to append
/// - Returns: new matrix with appended row
public func append(_ m: Matrix, row: Double) -> Matrix {
    let r = Vector(repeating: row, count: m.cols)
    return append(m, row: r)
}

/// Append rows to matrix.
///
/// Alternatively, `append(m, rows: rows)` can be executed with `m === rows`.
///
/// - Parameters:
///    - m: matrix
///    - rows: rows values to append represented as matrix
/// - Returns: new matrix with appended rows
public func append(_ m: Matrix, rows: Matrix) -> Matrix {
    return insert(m, rows: rows, at: m.rows)
}

/// Append rows to matrix.
///
/// - Parameters:
///    - m: matrix
///    - rows: rows values to append represented as array of vectors
/// - Returns: new matrix with appended rows
public func append(_ m: Matrix, rows: [Vector]) -> Matrix {
    return append(m, rows: Matrix(rows))
}

/// Append row to matrix constructed from scalar value.
///
/// Alternatively, `m === row` can be executed with `append(m, row: row)`.
///
/// - Parameters:
///    - m: matrix
///    - row: row value to append
/// - Returns: new matrix with appended row
public func === (_ m: Matrix, _ row: Double) -> Matrix {
    return append(m, row: row)
}

/// Append row to matrix.
///
/// Alternatively, `m === row` can be executed with `append(m, row: row)`.
///
/// - Parameters:
///    - m: matrix
///    - row: row values to append
/// - Returns: new matrix with appended row
public func === (_ m: Matrix, _ row: Vector) -> Matrix {
    return append(m, row: row)
}

/// Prepend row to matrix.
///
/// - Parameters:
///    - m: matrix
///    - row: row values to prepend represented as row matrix
/// - Returns: new matrix with prepended row
public func prepend(_ m: Matrix, row: Matrix) -> Matrix {
    precondition(row.cols == m.cols && row.rows == 1, "Input dimensions must agree")
    return insert(m, row: row.flat, at: 0)
}

/// Prepend row to matrix.
///
/// Alternatively, `prepend(m, row: row)` can be executed with `row === m`.
///
/// - Parameters:
///    - m: matrix
///    - row: row values to prepend
/// - Returns: new matrix with prepended row
public func prepend(_ m: Matrix, row: Vector) -> Matrix {
    let r = Matrix([row])
    return prepend(m, row: r)
}

/// Prepend row to matrix constructed from scalar value.
///
/// Alternatively, `prepend(m, row: row)` can be executed with `row === m`.
///
/// - Parameters:
///    - m: matrix
///    - row: row value to prepend
/// - Returns: new matrix with prepended row
public func prepend(_ m: Matrix, row: Double) -> Matrix {
    let r = Vector(repeating: row, count: m.cols)
    return prepend(m, row: r)
}

/// Prepend rows to matrix.
///
/// Alternatively, `prepend(m, rows: rows)` can be executed with `rows === m`.
///
/// - Parameters:
///    - m: matrix
///    - rows: rows values to prepend represented as matrix
/// - Returns: new matrix with prepended rows
public func prepend(_ m: Matrix, rows: Matrix) -> Matrix {
    return insert(m, rows: rows, at: 0)
}

/// Prepend rows to matrix.
///
/// - Parameters:
///    - m: matrix
///    - rows: rows values to prepended represented as array of vectors
/// - Returns: new matrix with prepended rows
public func prepend(_ m: Matrix, rows: [Vector]) -> Matrix {
    return prepend(m, rows: Matrix(rows))
}

/// Prepend row to matrix constructed from scalar value.
///
/// Alternatively, `row === m` can be executed with `prepend(m, row: row)`.
///
/// - Parameters:
///    - row: row value to prepend
///    - m: matrix
/// - Returns: new matrix with prepended row
public func === (_ row: Double, _ m: Matrix) -> Matrix {
    return prepend(m, row: row)
}

/// Prepend row to matrix.
///
/// Alternatively, `row === m` can be executed with `prepend(m, row: row)`.
///
/// - Parameters:
///    - row: row values to prepend
///    - m: matrix
/// - Returns: new matrix with prepended row
public func === (_ row: Vector, _ m: Matrix) -> Matrix {
    return prepend(m, row: row)
}

/// Horizontally concatenate two matrices.
/// It is similar to appending rhs as rows to lhs
///
/// Alternatively, `lhs === rhs` can be executed with `append(lhs, rows: rhs)`.
public func === (_ lhs: Matrix, _ rhs: Matrix) -> Matrix {
    return append(lhs, rows: rhs)
}

/// Insert column to matrix at specified position.
///
/// - Parameters:
///    - m: matrix
///    - cols: column values to insert
///    - at: index to insert column to
/// - Returns: new matrix with inserted column
public func insert(_ m: Matrix, col: Vector, at index: Int) -> Matrix {
    return insert(m, cols: Matrix(col), at: index)
}

/// Insert columns to matrix at specified position.
///
/// - Parameters:
///    - m: matrix
///    - cols: columns values to insert represented as matrix
///    - at: index to insert columns to
/// - Returns: new matrix with inserted columns
public func insert(_ m: Matrix, cols: Matrix, at index: Int) -> Matrix {
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

/// Append column to matrix.
///
/// - Parameters:
///    - m: matrix
///    - col: column values to append represented as column matrix
/// - Returns: new matrix with appended column
public func append(_ m: Matrix, col: Matrix) -> Matrix {
    precondition(col.rows == m.rows && col.cols == 1, "Input dimensions must agree")
    return insert(m, col: col.flat, at: m.cols)
}

/// Append column to matrix.
///
/// Alternatively, `append(m, col: col)` can be executed with `m ||| col`.
///
/// - Parameters:
///    - m: matrix
///    - col: column values to append
/// - Returns: new matrix with appended column
public func append(_ m: Matrix, col: Vector) -> Matrix {
    let c = Matrix(col.count, 1, col)
    return append(m, col: c)
}

/// Append column to matrix constructed from scalar value.
///
/// Alternatively, `append(m, col: col)` can be executed with `m ||| col`.
///
/// - Parameters:
///    - m: matrix
///    - col: column value to append
/// - Returns: new matrix with appended column
public func append(_ m: Matrix, col: Double) -> Matrix {
    let c = Vector(repeating: col, count: m.rows)
    return append(m, col: c)
}

/// Append columns to matrix.
///
/// Alternatively, `append(m, cols: cols)` can be executed with `m ||| cols`.
///
/// - Parameters:
///    - m: matrix
///    - cols: columns values to append represented as matrix
/// - Returns: new matrix with appended columns
public func append(_ m: Matrix, cols: Matrix) -> Matrix {
    return insert(m, cols: cols, at: m.cols)
}

/// Append columns to matrix.
///
/// - Parameters:
///    - m: matrix
///    - cols: columns values to append represented as array of vectors
/// - Returns: new matrix with appended columns
public func append(_ m: Matrix, cols: [Vector]) -> Matrix {
    return append(m, cols: transpose(Matrix(cols)))
}

/// Append column to matrix constructed from scalar value.
///
/// Alternatively, `m ||| col` can be executed with `append(m, col: col)`.
///
/// - Parameters:
///    - m: matrix
///    - col: column value to append
/// - Returns: new matrix with appended column
public func ||| (_ m: Matrix, _ col: Double) -> Matrix {
    return append(m, col: col)
}

/// Append column to matrix.
///
/// Alternatively, `m ||| col` can be executed with `append(m, col: col)`.
///
/// - Parameters:
///    - m: matrix
///    - col: column values to append
/// - Returns: new matrix with appended column
public func ||| (_ m: Matrix, _ col: Vector) -> Matrix {
    return append(m, col: col)
}

/// Prepend column to matrix.
///
/// - Parameters:
///    - m: matrix
///    - col: column values to prepend represented as column matrix
/// - Returns: new matrix with prepended column
public func prepend(_ m: Matrix, col: Matrix) -> Matrix {
    precondition(col.rows == m.rows && col.cols == 1, "Input dimensions must agree")
    return insert(m, col: col.flat, at: 0)
}

/// Prepend column to matrix.
///
/// Alternatively, `prepend(m, col: col)` can be executed with `col ||| m`.
///
/// - Parameters:
///    - m: matrix
///    - col: column values to prepend
/// - Returns: new matrix with prepended column
public func prepend(_ m: Matrix, col: Vector) -> Matrix {
    let c = Matrix(col)
    return prepend(m, col: c)
}

/// Prepend column to matrix constructed from scalar value.
///
/// Alternatively, `prepend(m, col: col)` can be executed with `col ||| m`.
///
/// - Parameters:
///    - m: matrix
///    - col: column value to prepend
/// - Returns: new matrix with prepended column
public func prepend(_ m: Matrix, col: Double) -> Matrix {
    let c = Vector(repeating: col, count: m.rows)
    return prepend(m, col: c)
}

/// Prepend columns to matrix.
///
/// Alternatively, `prepend(m, cols: cols)` can be executed with `cols ||| m`.
///
/// - Parameters:
///    - m: matrix
///    - cols: columns values to prepend represented as matrix
/// - Returns: new matrix with prepended columns
public func prepend(_ m: Matrix, cols: Matrix) -> Matrix {
    return insert(m, cols: cols, at: 0)
}

/// Prepend columns to matrix.
///
/// - Parameters:
///    - m: matrix
///    - cols: columns values to prepended represented as array of vectors
/// - Returns: new matrix with prepended columns
public func prepend(_ m: Matrix, cols: [Vector]) -> Matrix {
    return prepend(m, cols: transpose(Matrix(cols)))
}

/// Prepend column to matrix constructed from scalar value.
///
/// Alternatively, `col ||| m` can be executed with `prepend(m, col: col)`.
///
/// - Parameters:
///    - col: column value to prepend
///    - m: matrix
/// - Returns: new matrix with prepended column
public func ||| (_ col: Double, _ m: Matrix) -> Matrix {
    return prepend(m, col: col)
}

/// Prepend column to matrix.
///
/// Alternatively, `col ||| m` can be executed with `prepend(m, col: col)`.
///
/// - Parameters:
///    - col: column values to prepend
///    - m: matrix
/// - Returns: new matrix with prepended column
public func ||| (_ col: Vector, _ m: Matrix) -> Matrix {
    return prepend(m, col: col)
}

/// Vertically concatenate two matrices.
/// It is similar to appending rhs as columns to lhs
///
/// Alternatively, `lhs ||| rhs` can be executed with `append(lhs, cols: rhs)`.
public func ||| (_ lhs: Matrix, _ rhs: Matrix) -> Matrix {
    return append(lhs, cols: rhs)
}

// MARK: - Slicing

/// Matrix extractor.
///
/// - All: Take all rows/columns from source matrix.
/// - Range: Take rows/columns from source matrix with indices
///          starting at `from` with `stride` ending at `to`.
/// - Pos: Take rows/columns from source matrix at specified positions
/// - PosCyc: Take rows/columns from source matrix at specified cyclic positions
/// - Take: Take first `n` rows/columns from source matrix
/// - TakeLast: Take last `n` rows/columns from source matrix
/// - Drop: Drop first `n` rows/columns from source matrix
/// - DropLast: Drop last `n` rows/columns from source matrix
public enum Extractor {
    case All
    case Range(Int, Int, Int)
    case Pos([Int])
    case PosCyc([Int])
    case Take(Int)
    case TakeLast(Int)
    case Drop(Int)
    case DropLast(Int)
}

/// Construct new matrix from source using specified extractor
///
/// Alternatively, `slice(m, e)` can be executed with `m ?? e` or `m[e]`.
///
/// - Parameters
///     - m: source matrix
///     - e: extractor tuple for rows and columns
/// - Returns: extracted matrix
public func slice(_ m: Matrix, _ e: (er: Extractor, ec: Extractor)) -> Matrix {
    switch e {
        
    case (.All, .All):
        return m
        
    case (.Range(let f, _, let t), _) where f < 0 || t >= m.rows,
         (_, .Range(let f, _, let t)) where f < 0 || t >= m.cols,
         (.Range(let f, _, let t), _) where f >= m.rows || t < 0,
         (_, .Range(let f, _, let t)) where f >= m.cols || t < 0:
        preconditionFailure("Range out of bounds")
        
    case (.Take(let n), _) where n < 0 || n >= m.rows,
         (_, .Take(let n)) where n < 0 || n >= m.cols,
         (.Drop(let n), _) where n < 0 || n >= m.rows,
         (_, .Drop(let n)) where n < 0 || n >= m.cols:
        preconditionFailure("Range out of bounds")
        
    case (.All, _):
        return slice(m, (.Pos([Int](0..<m.rows)), e.ec))
    case (_, .All):
        return slice(m, (e.er, .Pos([Int](0..<m.cols))))
        
    case (.Range(let f, let b, let t), _):
        return slice(m, (.PosCyc([Int](stride(from: f, through: t, by: b))), e.ec))
    case (_, .Range(let f, let b, let t)):
        return slice(m, (e.er, .PosCyc([Int](stride(from: f, through: t, by: b)))))
        
    case (.PosCyc(let p), _):
        return slice(m, (.Pos(p.map { $0 %% m.rows }), e.ec))
    case (_, .PosCyc(let p)):
        return slice(m, (e.er, .Pos(p.map { $0 %% m.cols })))
        
    case (.TakeLast(let n), _):
        return slice(m, (.Drop(m.rows - n), e.ec))
    case (_, .TakeLast(let n)):
        return slice(m, (e.er, .Drop(m.cols - n)))
        
    case (.DropLast(let n), _):
        return slice(m, (.Take(m.rows - n), e.ec))
    case (_, .DropLast(let n)):
        return slice(m, (e.er, .Take(m.cols - n)))
        
    case (.Take(let n), _):
        return slice(m, (.Pos([Int](0..<n)), e.ec))
    case (_, .Take(let n)):
        return slice(m, (e.er, .Pos([Int](0..<n))))
        
    case (.Drop(let n), _):
        return slice(m, (.Pos([Int](n..<m.rows)), e.ec))
    case (_, .Drop(let n)):
        return slice(m, (e.er, .Pos([Int](n..<m.cols))))
        
    case (.Pos(let pr), .Pos(let pc)):
        precondition(pr.count > 0 && pr.filter { $0 < 0 || $0 > m.rows }.count == 0, "Range out of bounds")
        precondition(pc.count > 0 && pc.filter { $0 < 0 || $0 > m.cols }.count == 0, "Range out of bounds")
        return slice(m, pr, pc)
        
    default:
        preconditionFailure("Invalid range")
    }
}

func slice(_ m: Matrix, _ rr: [Int], _ cr: [Int]) -> Matrix {
    let res = zeros(rr.count, cr.count)
    
    // vgathrD is using 1-based indices
    let _cr = cr.map { vDSP_Length($0 + 1) }
    
    _ = zip(rr, (0..<res.rows)).map { (i: Int, j: Int) -> () in
        var row = zeros(res.cols)
        m.flat.withUnsafeBufferPointer { bufPtr in
            let p = bufPtr.baseAddress! + i * m.cols
            vDSP_vgathrD(p, _cr, 1, &row, 1, vDSP_Length(res.cols))
        }
        res.flat.withUnsafeMutableBufferPointer { bufPtr in
            let p = bufPtr.baseAddress! + j * res.cols
            vDSP_mmovD(row, p, vDSP_Length(res.cols), vDSP_Length(1), vDSP_Length(res.cols), vDSP_Length(res.cols))
        }
    }
    
    return res
}

/// Construct new matrix from source using specified extractor.
///
/// Alternatively, `m ?? e` can be executed with `slice(m, e)` or `m[e]`.
///
/// - Parameters
///     - m: source matrix
///     - e: extractor tuple for rows and columns
/// - Returns: extracted matrix
public func ?? (_ m: Matrix, _ e: (er: Extractor, ec: Extractor)) -> Matrix {
    return slice(m, e)
}

// MARK: - Map-reduce

/// Map all elements of source matrix to new matrix using specified function.
///
/// - Parameters
///     - A: source matrix
///     - f: mapping function
/// - Returns: mapped matrix
public func map(_ A: Matrix, _ f: ((Double) -> Double)) -> Matrix {
    return Matrix(A.rows, A.cols, A.flat.map(f))
}

/// Map all elements of source matrix to new matrix using specified function
/// which operates on vectors.
///
/// - Parameters
///     - A: source matrix
///     - f: mapping function
/// - Returns: mapped matrix
public func map(_ A: Matrix, _ f: ((Vector) -> Vector)) -> Matrix {
    return matrixFunction(f, A)
}

/// Perform reduce operation on a matrix using specified function
/// within the specified dimension.
///
/// - Parameters
///     - A: source matrix
///     - f: reducing function
///     - d: dimesion to apply reduce within (Row by default)
/// - Returns: vector of reduced values
public func reduce(_ A: Matrix, _ f: ((Vector) -> Double), _ d: Dim = .Row) -> Vector {
    return aggMatrixFunction(f, A, d)
}

// MARK: - Sequence

extension Matrix: Sequence {
    public typealias MatrixIterator = AnyIterator<ArraySlice<Double>>
    /// Iterate through matrix by rows
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

// MARK: - Matrix comparison

extension Matrix: Equatable {}

/// Check if two matrices are equal using Double value approximate comparison
public func == (lhs: Matrix, rhs: Matrix) -> Bool {
    return lhs.rows == rhs.rows && lhs.cols == rhs.cols && lhs.flat ==~ rhs.flat
}

/// Check if two matrices are not equal using Double value approximate comparison
public func != (lhs: Matrix, rhs: Matrix) -> Bool {
    return lhs.rows != rhs.rows || lhs.cols != rhs.cols || lhs.flat !=~ rhs.flat
}

extension Matrix: Comparable {}

/// Check if one matrix is greater than another using Double value approximate comparison
public func > (lhs: Matrix, rhs: Matrix) -> Bool {
    return lhs.rows == rhs.rows && lhs.cols == rhs.cols && lhs.flat >~ rhs.flat
}

/// Check if one matrix is less than another using Double value approximate comparison
public func < (lhs: Matrix, rhs: Matrix) -> Bool {
    return lhs.rows == rhs.rows && lhs.cols == rhs.cols && lhs.flat <~ rhs.flat
}

/// Check if one matrix is greater than or equal to another using Double value approximate comparison
public func >= (lhs: Matrix, rhs: Matrix) -> Bool {
    return lhs.rows == rhs.rows && lhs.cols == rhs.cols && lhs.flat >=~ rhs.flat
}

/// Check if one matrix is less than or equal to another using Double value approximate comparison
public func <= (lhs: Matrix, rhs: Matrix) -> Bool {
    return lhs.rows == rhs.rows && lhs.cols == rhs.cols && lhs.flat <=~ rhs.flat
}
