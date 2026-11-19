//
//  RandomTests.swift
//  LASwift
//
//  Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
//  All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the BSD license. See the LICENSE file for details.
//

@testable import LASwift
import Testing

@Suite("Seeded random values")
struct SeededRandomTests {
    @Test("the same seed gives the same rand vector")
    func randVector() {
        #expect(rand(50, seed: 42) == rand(50, seed: 42))
    }

    @Test("the same seed gives the same randn vector")
    func randnVector() {
        #expect(randn(50, seed: 42) == randn(50, seed: 42))
    }

    @Test("the same seed gives the same matrix, equal to the vector of the same length")
    func matrices() {
        #expect(rand(4, 5, seed: 7) == rand(4, 5, seed: 7))
        #expect(randn(4, 5, seed: 7) == randn(4, 5, seed: 7))
        #expect(rand(4, 5, seed: 7).flat == rand(20, seed: 7))
        #expect(randn(4, 5, seed: 7).flat == randn(20, seed: 7))
    }

    @Test("different seeds give different values")
    func differentSeeds() {
        #expect(rand(50, seed: 1) != rand(50, seed: 2))
        #expect(randn(50, seed: 1) != randn(50, seed: 2))
        #expect(rand(50, seed: 0) != rand(50, seed: 1))
    }

    @Test("without a seed, values differ between calls")
    func unseeded() {
        #expect(rand(50) != rand(50))
        #expect(randn(50) != randn(50))
    }

    @Test("seeded values keep their distribution")
    func distribution() {
        let u = rand(20000, seed: 3)
        #expect(u.allSatisfy { $0 >= 0.0 && $0 < 1.0 })
        expectClose(mean(u), 0.5, tol: 0.02)
        let n = randn(20000, seed: 3)
        expectClose(mean(n), 0.0, tol: 0.05)
        expectClose(std(n), 1.0, tol: 0.05)
    }
}

@Suite("LAPACK seed contract")
struct LapackSeedTests {
    // dlarnv: "ISEED ... the array elements must be between 0 and 4095, and ISEED(4) must be odd."
    @Test("generated seeds are valid for dlarnv")
    func validSeeds() {
        var seeds: [UInt64?] = [nil, 0, 1, 2, UInt64.max]
        seeds += (0..<2000).map { _ in UInt64.random(in: 0...UInt64.max) }
        seeds += (0..<1000).map { _ in nil }
        for seed in seeds {
            let s = Random.iSeed(seed)
            #expect(s.count == 4)
            #expect(s.allSatisfy { (0...4095).contains($0) }, "seed \(String(describing: seed)): \(s)")
            #expect(s[3] % 2 == 1, "seed \(String(describing: seed)): ISEED(4) is even: \(s)")
        }
    }
}
