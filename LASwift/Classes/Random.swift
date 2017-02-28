//
//  Random.swift
//  Pods
//
//  Created by Alexander Taraymovich on 28/02/2017.
//
//

public struct Random {
    static func within<T>(_ range: ClosedRange<T>) -> T
        where T: FloatingPoint, T: ExpressibleByFloatLiteral {
            return (range.upperBound - range.lowerBound) *
                (T(arc4random()) / T(UInt32.max)) + range.lowerBound
    }
    
    public static func generate<T>() -> T
        where T: FloatingPoint, T: ExpressibleByFloatLiteral {
            return within(0.0...1.0)
    }
}
