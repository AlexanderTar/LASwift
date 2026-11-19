// Operators.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

/// Binds tighter than multiplication, so `2 .* a .** 2` squares `a` first.
precedencegroup ExponentiationPrecedence {
    associativity: right
    higherThan: MultiplicationPrecedence
}

/// Matrix power: `A ** 2` is `mpower(A, 2)`.
infix operator ** : ExponentiationPrecedence

/// Elementwise power: `a .** 2` is `power(a, 2)`.
infix operator .** : ExponentiationPrecedence

infix operator .* : MultiplicationPrecedence
infix operator ./ : MultiplicationPrecedence
infix operator ./. : MultiplicationPrecedence

postfix operator ′ 

infix operator ||| : DefaultPrecedence
