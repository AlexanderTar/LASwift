//
//  VectorTests.swift
//  LASwift
//
//  Created by Alexander Taraymovich on 22/02/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import LASwift

class VectorSpec: QuickSpec {
    override func spec() {
        describe("Vector construction tests") {
            
            let vec1: [Double] = ones(10)
            
            it("ones vector has correct size") {
                expect(vec1.count) == 10
            }
            
            it("ones vector all ones") {
                for elem in vec1 {
                    expect(elem) == 1.0
                }
            }
            
            let vec2: [Double] = zeros(10)
            
            it("zeros vector has correct size") {
                expect(vec2.count) == 10
            }
            
            it("zeros vector all zeros") {
                for elem in vec2 {
                    expect(elem) == 0.0
                }
            }
            
            let vec3: [Double] = zeros(10)
            
            it("zeros vectors are equal") {
                expect(vec3) == vec2
            }
            
            it("zeros and ones vectors are not equal") {
                expect(vec2) != vec1
            }
            
            let vec4 = [Double](repeating: 1.0, count: 10)
            
            it("differently constructed ones vectors are equal") {
                expect(vec1) == vec4
            }
        }
    }
}

