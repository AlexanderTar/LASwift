//
//  VectorTests.swift
//  LASwift
//
//  Created by Alexander Taraymovich on 22/02/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Darwin
import Quick
import Nimble
import LASwift

class VectorSpec: QuickSpec {
    override func spec() {
        describe("Vector construction tests") {
            
            let vec1 = ones(10)
            
            it("ones vector has correct size") {
                expect(vec1.count) == 10
            }
            
            it("ones vector all ones") {
                for elem in vec1 {
                    expect(elem) == 1.0
                }
            }
            
            let vec2 = zeros(10)
            
            it("zeros vector has correct size") {
                expect(vec2.count) == 10
            }
            
            it("zeros vector all zeros") {
                for elem in vec2 {
                    expect(elem) == 0.0
                }
            }
            
            let vec3 = zeros(10)
            
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
        
        describe("Vector comparison") {
            it("equal") {
                let v1 = [1.0, 2.0]
                let v2 = [1.0, 2.0]
                expect(v1 == v2) == true
            }
            it("not equal") {
                let v1 = [1.0, 2.0]
                let v2 = [1.0, 4.0]
                expect(v1 != v2) == true
            }
            it("greater/less than") {
                let v1 = [11.0, 12.0]
                let v2 = [1.0, 2.0]
                expect(v1 > v2) == true
                expect(v2 < v1) == true
            }
            it("greater/less than or equal") {
                let v1 = [11.0, 12.0]
                let v2 = [1.0, 2.0]
                let v3 = [1.0, 2.0]
                expect(v1 >= v2) == true
                expect(v2 <= v1) == true
                expect(v2 >= v3) == true
                expect(v2 <= v3) == true
            }
        }
        describe("Vector arithmetic tests") {            
            it("addition") {
                let vec1 = [1.0, 2.0, 3.0]
                let vec2 = [4.0, 5.0, 6.0]
                let res = [5.0, 7.0, 9.0]
                expect(vec1 + vec2).to(beCloseTo(res))
            }
            
            it("substraction") {
                let vec1 = [1.0, 2.0, 3.0]
                let vec2 = [4.0, 5.0, 6.0]
                let res = [-3.0, -3.0, -3.0]
                expect(vec1 - vec2).to(beCloseTo(res))
            }
            
            it("multiplication") {
                let vec1 = [1.0, 2.0, 3.0]
                let vec2 = [4.0, 5.0, 6.0]
                let res = [4.0, 10.0, 18.0]
                expect(vec1 .* vec2).to(beCloseTo(res))
            }
            
            it("right division") {
                let vec1 = [1.0, 2.0, 3.0]
                let vec2 = [4.0, 5.0, 6.0]
                let res = [1.0 / 4.0, 2.0 / 5.0, 3.0 / 6.0]
                expect(vec1 ./ vec2).to(beCloseTo(res))
            }
            
            it("left division") {
                let vec1 = [1.0, 2.0, 3.0]
                let vec2 = [4.0, 5.0, 6.0]
                let res = [4.0 / 1.0, 5.0 / 2.0, 6.0 / 3.0]
                expect(vec1 ./. vec2).to(beCloseTo(res))
            }
            
            it("scalar addition") {
                let vec = [1.0, 2.0, 3.0]
                let s = 7.0
                let res = [8.0, 9.0, 10.0]
                expect(vec + s).to(beCloseTo(res))
                expect(s + vec).to(beCloseTo(res))
            }
            
            it("scalar substraction") {
                let vec = [1.0, 2.0, 3.0]
                let s = 7.0
                let res1 = [-6.0, -5.0, -4.0]
                let res2 = [6.0, 5.0, 4.0]
                expect(vec - s).to(beCloseTo(res1))
                expect(s - vec).to(beCloseTo(res2))
            }
            
            it("scalar multiplication") {
                let vec = [1.0, 2.0, 3.0]
                let s = 7.0
                let res = [7.0, 14.0, 21.0]
                expect(vec .* s).to(beCloseTo(res))
                expect(s .* vec).to(beCloseTo(res))
            }
            
            it("scalar right division") {
                let vec = [1.0, 2.0, 3.0]
                let s = 7.0
                let res1 = [1.0 / 7.0, 2.0 / 7.0, 3.0 / 7.0]
                let res2 = [7.0 / 1.0, 7.0 / 2.0, 7.0 / 3.0]
                expect(vec ./ s).to(beCloseTo(res1))
                expect(s ./ vec).to(beCloseTo(res2))
            }
            
            it("scalar left division") {
                let vec = [1.0, 2.0, 3.0]
                let s = 7.0
                let res1 = [7.0 / 1.0, 7.0 / 2.0, 7.0 / 3.0]
                let res2 = [1.0 / 7.0, 2.0 / 7.0, 3.0 / 7.0]
                expect(vec ./. s).to(beCloseTo(res1))
                expect(s ./. vec).to(beCloseTo(res2))
            }
            
            it("negation") {
                let vec = [1.0, -2.0, 3.0]
                let res = [-1.0, 2.0, -3.0]
                expect(-vec).to(beCloseTo(res))
            }
            
            it("absolute") {
                let vec = [1.0, -2.0, 3.0]
                let res = [1.0, 2.0, 3.0]
                expect(abs(vec)).to(beCloseTo(res))
            }
            
            it("threshold") {
                let vec = [1.0, -2.0, 3.0]
                let res = [1.0, 0.0, 3.0]
                expect(thr(vec, 0.0)).to(beCloseTo(res))
            }
            
            it("dot product") {
                let vec1 = [1.0, 2.0, 3.0]
                let vec2 = [4.0, 5.0, 6.0]
                let res = 32.0
                expect(vec1 * vec2).to(beCloseTo(res))
            }
        }
        
        describe("Vector power and exponential tests") {
            it("power") {
                let vec = [1.0, 2.0, 3.0]
                let p = 3.0
                let res = [1.0, 8.0, 27.0]
                expect(vec .^ p).to(beCloseTo(res))
            }
            it("square") {
                let vec = [1.0, 2.0, 3.0]
                let res = [1.0, 4.0, 9.0]
                expect(square(vec)).to(beCloseTo(res))
                expect(square(vec)).to(beCloseTo(vec .^ 2))
            }
            it("sqrt") {
                let vec = [1.0, 2.0, 3.0]
                let res = [sqrt(1.0), sqrt(2.0), sqrt(3.0)]
                expect(sqrt(vec)).to(beCloseTo(res))
                expect(sqrt(vec)).to(beCloseTo(vec .^ 0.5))
            }
            it("exp") {
                let vec = [1.0, 2.0, 3.0]
                let res = [exp(1.0), exp(2.0), exp(3.0)]
                expect(exp(vec)).to(beCloseTo(res))
            }
            it("log") {
                let vec = [1.0, 2.0, 3.0]
                let res = [log(1.0), log(2.0), log(3.0)]
                expect(log(vec)).to(beCloseTo(res))
            }
            it("log10") {
                let vec = [1.0, 2.0, 3.0]
                let res = [log10(1.0), log10(2.0), log10(3.0)]
                expect(log10(vec)).to(beCloseTo(res))
            }
            it("log2") {
                let vec = [1.0, 2.0, 3.0]
                let res = [log2(1.0), log2(2.0), log2(3.0)]
                expect(log2(vec)).to(beCloseTo(res))
            }
        }
        
        describe("Vector trigonometric tests") {
            it("sin") {
                let vec = [1.0, 2.0, 3.0]
                let res = [sin(1.0), sin(2.0), sin(3.0)]
                expect(sin(vec)).to(beCloseTo(res))
            }
            it("cos") {
                let vec = [1.0, 2.0, 3.0]
                let res = [cos(1.0), cos(2.0), cos(3.0)]
                expect(cos(vec)).to(beCloseTo(res))
            }
            it("tan") {
                let vec = [1.0, 2.0, 3.0]
                let res = [tan(1.0), tan(2.0), tan(3.0)]
                expect(tan(vec)).to(beCloseTo(res))
            }
        }
        
        describe("Vector statistics tests") {
            it("max") {
                let vec = [1.0, 3.0, 2.0]
                let res = 3.0
                expect(max(vec)).to(beCloseTo(res))
            }
            it("maxi") {
                let vec = [1.0, 3.0, 2.0]
                let res = 1
                expect(maxi(vec)) == res
            }
            it("min") {
                let vec = [3.0, 1.0, 2.0]
                let res = 1.0
                expect(min(vec)).to(beCloseTo(res))
            }
            it("mini") {
                let vec = [3.0, 1.0, 2.0]
                let res = 1
                expect(mini(vec)) == res
            }
            it("mean") {
                let vec = [1.0, 2.0, 3.0]
                let res = 2.0
                expect(mean(vec)).to(beCloseTo(res))
            }
            it("std") {
                let vec = [1.0, 2.0, 3.0]
                let res = sqrt(2.0 / 3.0)
                expect(std(vec)).to(beCloseTo(res))
            }
            it("sum") {
                let vec = [1.0, 2.0, 3.0]
                let res = 6.0
                expect(sum(vec)).to(beCloseTo(res))
            }
            it("sumsq") {
                let vec = [1.0, 2.0, 3.0]
                let res = 14.0
                expect(sumsq(vec)).to(beCloseTo(res))
            }
            it("normalize") {
                let vec = [1.0, 2.0, 3.0]
                let m = mean(vec)
                let s = std(vec)
                let res = [(1.0 - m) / s, (2.0 - m) / s, (3.0 - m) / s]
                expect(normalize(vec)).to(beCloseTo(res))
            }
        }
    }
}
