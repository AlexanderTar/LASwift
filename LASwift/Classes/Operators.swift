//
//  Operators.swift
//  Pods
//
//  Created by Alexander Taraymovich on 05/03/2017.
//
//

infix operator .* : MultiplicationPrecedence
infix operator ./ : MultiplicationPrecedence
infix operator ./. : MultiplicationPrecedence
infix operator .^ : MultiplicationPrecedence

postfix operator ′

infix operator ||| : DefaultPrecedence
