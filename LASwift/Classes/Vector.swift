//
//  Vector.swift
//  Pods
//
//  Created by Alexander Taraymovich on 22/02/2017.
//
//

import Foundation

public class Vector<T> where T: FloatingPoint, T: ExpressibleByFloatLiteral {
    fileprivate var raw = [T]()
    
    public var count: Int  {
        return raw.count
    }
    
    public init(_ elements: [T]) {
        raw = elements
    }
    
    public init(repeating: T, count: Int) {
        raw = [T](repeating: repeating, count: count)
    }
    
    public subscript(_ index: Int) -> T {
        get {
            precondition(index < raw.count)
            return raw[index]
        }
        
        set {
            precondition(index < raw.count)
            raw[index] = newValue
        }
    }
    
    public static func zeros(_ size: Int) -> Vector {
        return Vector<T>(repeating: 0.0, count: size)
    }
    
    public static func ones(_ size: Int) -> Vector {
        return Vector<T>(repeating: 1.0, count: size)
    }
}

// MARK: - Printable

extension Vector: CustomStringConvertible {
    public var description: String {
        return "\((0..<count).map{"\(self[$0])"}.joined(separator: " "))"
    }
}

// MARK: - Sequence

extension Vector: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        var index = 0
        
        return AnyIterator {
            if index == self.count {
                return nil
            }
            
            index += 1
            
            return self.raw[index - 1]
        }
    }
}

// MARK: - Equatable

extension Vector: Equatable {}
public func ==<T> (lhs: Vector<T>, rhs: Vector<T>) -> Bool {
    return lhs.raw == rhs.raw
}
