// Random.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.

/// Seeds for LAPACK's `dlarnv` random number generator.
struct Random {
    /// Build the `ISEED` array `dlarnv` needs: four integers in 0...4095 with `ISEED(4)` odd.
    ///
    /// The same `seed` always gives the same array; `nil` draws a fresh seed from the
    /// system random number generator. Only 47 bits of state fit in `ISEED`, so seeds
    /// that differ only above those bits (after mixing) can still give equal streams.
    static func iSeed(_ seed: UInt64?) -> [Int] {
        var z = seed ?? UInt64.random(in: .min ... .max)
        // SplitMix64 finaliser: spreads neighbouring seeds (0, 1, 2, ...) over all bits.
        z &+= 0x9E37_79B9_7F4A_7C15
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        z ^= z >> 31
        var iSeed = (0..<4).map { Int((z >> UInt64(12 * $0)) & 0xFFF) }
        iSeed[3] |= 1  // dlarnv requires ISEED(4) to be odd.
        return iSeed
    }
}
