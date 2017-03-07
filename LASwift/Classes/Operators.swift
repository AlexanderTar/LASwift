// Operators.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

infix operator .* : MultiplicationPrecedence
infix operator ./ : MultiplicationPrecedence
infix operator ./. : MultiplicationPrecedence
infix operator .^ : MultiplicationPrecedence

postfix operator ′ 

infix operator ||| : DefaultPrecedence
