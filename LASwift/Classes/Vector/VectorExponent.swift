// VectorExponent.swift
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

import Accelerate

// MARK: - Power and exponential operations on vector

public func power(_ a: Vector, _ p: Double) -> Vector {
    var c = Vector(repeating: 0.0, count: a.count)
    var l = Int32(a.count)
    var p = p
    vvpows(&c, &p, a, &l)
    return c
}

public func .^ (_ a: Vector, _ p: Double) -> Vector {
    return power(a, p)
}

public func square(_ a: Vector) -> Vector {
    return unaryOperation(vDSP_vsqD, a)
}

public func sqrt(_ a: Vector) -> Vector {
    return unaryFunction(vvsqrt, a)
}

public func exp(_ a: Vector) -> Vector {
    return unaryFunction(vvexp, a)
}

public func log(_ a: Vector) -> Vector {
    return unaryFunction(vvlog, a)
}

public func log2(_ a: Vector) -> Vector {
    return unaryFunction(vvlog2, a)
}

public func log10(_ a: Vector) -> Vector {
    return unaryFunction(vvlog10, a)
}
