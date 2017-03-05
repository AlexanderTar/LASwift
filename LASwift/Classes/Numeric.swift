//
//  Numeric.swift
//  Pods
//
//  Created by Alexander Taraymovich on 04/03/2017.
//
//

import Foundation

precedencegroup EquivalencePrecedence {
    higherThan: ComparisonPrecedence
    lowerThan: AdditionPrecedence
}

infix operator ==~ : EquivalencePrecedence
infix operator !=~ : EquivalencePrecedence
infix operator <=~ : ComparisonPrecedence
infix operator >=~ : ComparisonPrecedence
infix operator <~ : ComparisonPrecedence
infix operator >~ : ComparisonPrecedence

// MARK: - Double equality and comparison

let deps: Double = 1e-14

func ==~ (left: Double, right: Double) -> Bool
{
    return fabs(left.distance(to: right)) <= deps
}

func !=~ (left: Double, right: Double) -> Bool
{
    return !(left ==~ right)
}

func <=~ (left: Double, right: Double) -> Bool
{
    return left ==~ right || left <~ right
}

func >=~ (left: Double, right: Double) -> Bool
{
    return left ==~ right || left >~ right
}

func <~ (left: Double, right: Double) -> Bool
{
    return left.distance(to: right) > deps
}

func >~ (left: Double, right: Double) -> Bool
{
    return left.distance(to: right) < -deps
}

// MARK: Double array equality

func ==~ (left: [Double], right: [Double]) -> Bool
{
    return left.count == right.count &&
        zip(left, right).filter { (l, r) in l !=~ r }.count == 0
}

func !=~ (left: [Double], right: [Double]) -> Bool
{
    return left.count != right.count ||
        zip(left, right).filter { (l, r) in l !=~ r }.count != 0
}
