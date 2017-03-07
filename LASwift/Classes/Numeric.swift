// Numeric.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//
// * Redistributions in binary form must reproduce the above
// copyright notice, this list of conditions and the following
// disclaimer in the documentation and/or other materials provided
// with the distribution.
//
// * Neither the name of Alexander Taraymovich nor the names of other
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
