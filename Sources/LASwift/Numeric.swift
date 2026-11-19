// Numeric.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

import Darwin

// MARK: Modulo operation

infix operator %% : MultiplicationPrecedence

func mod(_ a: Int, _ n: Int) -> Int {
    let r = a % abs(n)
    return r >= 0 ? r : r + abs(n)
}

func %% (_ a: Int, _ n: Int) -> Int {
    return mod(a, n)
}
