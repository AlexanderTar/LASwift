//
//  PerformanceTests.swift
//  LASwift
//
//  Created by Alexander Taraymovich on 15/03/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import LASwift
import XCTest

class PerformanceTests: XCTestCase {
    let a = rand(1000, 1000)
    let b = rand(1000, 1000)
    let x = rand(1000000)
    let y = rand(1000000)
    
    func testRandomMatrix() {
        measure {
            _ = rand(1000, 1000)
        }
    }
    
    func testInvert() {
        measure {
            _ = inv(self.a)
        }
    }
    
    func testCholesky() {
        let aTa = transpose(a) * a
        measure {
            _ = chol(aTa)
        }
    }
    
    func testDot() {
        measure {
            _ = self.x * self.y
        }
    }
    
    func testTranspose() {
        measure {
            _ = transpose(self.a)
        }
    }
    
    func testMultiply() {
        measure {
            _ = self.a * self.b
        }
    }
    
    func testSigmoid() {
        measure {
            _ = 1 ./ (1 + exp(-self.a))
        }
    }
    
    func testReLU() {
        measure {
            _ = thr(self.a, 0)
        }
    }
    
    func testSumByRows() {
        measure {
            _ = sum(self.a, .Row)
        }
    }
    
    func testSumByColumns() {
        measure {
            _ = sum(self.a, .Column)
        }
    }
    
    func testMaxIndicesByRows() {
        measure {
            _ = maxi(self.a, .Row)
        }
    }
    
    func testMaxIndicesByColumns() {
        measure {
            _ = maxi(self.a, .Column)
        }
    }
}
