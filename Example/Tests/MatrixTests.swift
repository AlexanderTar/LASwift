//
//  MatrixTests.swift
//  LASwift
//
//  Created by Alexander Taraymovich on 28/02/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Darwin

import Quick
import Nimble
import LASwift

class MatrixSpec: QuickSpec {
    override func spec() {
        describe("Matrix construction tests") {
            let count = 10
            
            let m1 = ones(count, count+1)
            
            it("ones matrix has correct dimensions") {
                expect(m1.rows) == count
                expect(m1.cols) == count+1
            }
            
            it("ones matrix all ones") {
                for i in 0..<count {
                    for j in 0..<count+1 {
                        expect(m1[i, j]).to(beCloseTo(1.0))
                    }
                }
            }
            
            let m2 = zeros(count, count+1)
            
            it("zeros matrix has correct dimensions") {
                expect(m2.rows) == count
                expect(m2.cols) == count+1
            }
            
            it("zeros matrix all zeros") {
                for i in 0..<count {
                    for j in 0..<count+1 {
                        expect(m2[i, j]).to(beCloseTo(0.0))
                    }
                }

            }
            
            let m3 = zeros(count, count+1)
            
            it("zeros vectors are equal") {
                expect(m3) == m2
            }
            
            it("zeros and ones vectors are not equal") {
                expect(m2) != m1
            }
            
            let ones_like_m3 = ones(like: m3)   // input is zeros(count, count+1)
            
            it("ones like are equal") {
                expect(ones_like_m3) == m1      // test against ones(count, count+1)
            }
            
            let zeros_like_m1 = zeros(like: m1) // input is ones(count, count+1)
            
            it("zeros like are equal") {
                expect(zeros_like_m1) == m3     // test against zeros(count, count+1)
            }

            let m4 = eye(count, count)
            
            it("identity matrix has correct dimensions") {
                expect(m4.rows) == count
                expect(m4.cols) == count
            }
            
            it("identity matrix ones on diag") {
                for i in 0..<count {
                    for j in 0..<count {
                        if i == j {
                            expect(m4[i, j]).to(beCloseTo(1.0))
                        } else {
                            expect(m4[i, j]).to(beCloseTo(0.0))
                        }
                    }
                }
            }
            
            let v1 = [1.0, 2.0, 3.0, 4.0, 5.0]
            let v2 = Matrix(v1)
            let m5 = diag(v1)
            let m6 = diag(v2)
            let m7 = diag(v1.count + 2, v1.count, v2)
            
            it("diag matrix has correct dimensions") {
                expect(m5.rows) == v1.count
                expect(m5.cols) == v1.count
                expect(m6.rows) == v1.count
                expect(m6.cols) == v1.count
                expect(m7.rows) == v1.count + 2
                expect(m7.cols) == v1.count
            }
            
            it("diag matrix correct") {
                for i in 0..<v1.count {
                    for j in 0..<v1.count {
                        if i == j {
                            expect(m5[i, j]).to(beCloseTo(v1[i]))
                            expect(m6[i, j]).to(beCloseTo(v1[i]))
                            expect(m7[i, j]).to(beCloseTo(v1[i]))
                        } else {
                            expect(m5[i, j]).to(beCloseTo(0.0))
                            expect(m6[i, j]).to(beCloseTo(0.0))
                            expect(m7[i, j]).to(beCloseTo(0.0))
                        }
                    }
                }
            }
            
            it("rand") {
                let size = 100
                let m8 = rand(size, size)
                expect(m8.rows) == size
                expect(m8.cols) == size
                for i in 0..<size {
                    for j in 0..<size {
                        expect(m8[i, j]).to(beLessThan(1.0))
                        expect(m8[i, j]).to(beGreaterThanOrEqualTo(0.0))
                    }
                }
            }
            
            it("randn") {
                let m8 = randn(1000, 1000)
                expect(m8.rows) == 1000
                expect(m8.cols) == 1000
                let m = mean(m8)
                let s = std(m8)
                _ = (0..<1000).map { (i) in
                    expect(m[i]).to(beCloseTo(0.0, within: 0.2))
                    expect(s[i]).to(beCloseTo(1.0, within: 0.2))
                }
            }
            
        }
        describe("Matrix arithmetic tests") {
            it("addition") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let m2 = Matrix([[5.0, 6.0], [7.0, 8.0]])
                let res = Matrix([[6.0, 8.0], [10.0, 12.0]])
                expect(m1 + m2) == res
            }
            
            it("substraction") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let m2 = Matrix([[5.0, 6.0], [7.0, 8.0]])
                let res = Matrix([[-4.0, -4.0], [-4.0, -4.0]])
                expect(m1 - m2) == res
            }
            
            it("multiplication") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let m2 = Matrix([[5.0, 6.0], [7.0, 8.0]])
                let res = Matrix([[5.0, 12.0], [21.0, 32.0]])
                expect(m1 .* m2) == res
            }
            
            it("right division") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let m2 = Matrix([[5.0, 6.0], [7.0, 8.0]])
                let res = Matrix([[1.0 / 5.0, 2.0 / 6.0], [3.0 / 7.0, 4.0 / 8.0]])
                expect(m1 ./ m2) == res
            }
            
            it("left division") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let m2 = Matrix([[5.0, 6.0], [7.0, 8.0]])
                let res = Matrix([[5.0 / 1.0, 6.0 / 2.0], [7.0 / 3.0, 8.0 / 4.0]])
                expect(m1 ./. m2) == res
            }
            
            it("vector addition") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let v = [5.0, 6.0]
                let res = Matrix([[6.0, 8.0], [8.0, 10.0]])
                expect(m1 + v) == res
                expect(v + m1) == res
            }
            
            it("vector substraction") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let v = [5.0, 6.0]
                let res1 = Matrix([[-4.0, -4.0], [-2.0, -2.0]])
                let res2 = Matrix([[4.0, 4.0], [2.0, 2.0]])
                expect(m1 - v) == res1
                expect(v - m1) == res2
            }
            
            it("vector multiplication") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let v = [5.0, 6.0]
                let res = Matrix([[5.0, 12.0], [15.0, 24.0]])
                expect(m1 .* v) == res
                expect(v .* m1) == res
            }
            
            it("vector right division") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let v = [5.0, 6.0]
                let res1 = Matrix([[1.0 / 5.0, 2.0 / 6.0], [3.0 / 5.0, 4.0 / 6.0]])
                let res2 = Matrix([[5.0 / 1.0, 6.0 / 2.0], [5.0 / 3.0, 6.0 / 4.0]])
                expect(m1 ./ v) == res1
                expect(v ./ m1) == res2
            }
            
            it("vector left division") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let v = [5.0, 6.0]
                let res1 = Matrix([[5.0 / 1.0, 6.0 / 2.0], [5.0 / 3.0, 6.0 / 4.0]])
                let res2 = Matrix([[1.0 / 5.0, 2.0 / 6.0], [3.0 / 5.0, 4.0 / 6.0]])
                expect(m1 ./. v) == res1
                expect(v ./. m1) == res2
            }
            
            it("scalar addition") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let s = 5.0
                let res = Matrix([[6.0, 7.0], [8.0, 9.0]])
                expect(m1 + s) == res
                expect(s + m1) == res
            }
            
            it("scalar substraction") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let s = 5.0
                let res1 = Matrix([[-4.0, -3.0], [-2.0, -1.0]])
                let res2 = Matrix([[4.0, 3.0], [2.0, 1.0]])
                expect(m1 - s) == res1
                expect(s - m1) == res2
            }
            
            it("scalar multiplication") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let s = 5.0
                let res = Matrix([[5.0, 10.0], [15.0, 20.0]])
                expect(m1 .* s) == res
                expect(s .* m1) == res
            }
            
            it("scalar right division") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let s = 5.0
                let res1 = Matrix([[1.0 / 5.0, 2.0 / 5.0], [3.0 / 5.0, 4.0 / 5.0]])
                let res2 = Matrix([[5.0 / 1.0, 5.0 / 2.0], [5.0 / 3.0, 5.0 / 4.0]])
                expect(m1 ./ s) == res1
                expect(s ./ m1) == res2
            }
            
            it("scalar left division") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let s = 5.0
                let res1 = Matrix([[5.0 / 1.0, 5.0 / 2.0], [5.0 / 3.0, 5.0 / 4.0]])
                let res2 = Matrix([[1.0 / 5.0, 2.0 / 5.0], [3.0 / 5.0, 4.0 / 5.0]])
                expect(m1 ./. s) == res1
                expect(s ./. m1) == res2
            }
            
            it("negation") {
                let m1 = Matrix([[1.0, -2.0], [-3.0, 4.0]])
                let res = Matrix([[-1.0, 2.0], [3.0, -4.0]])
                expect(-m1) == res
            }
            
            it("absolute") {
                let m1 = Matrix([[1.0, -2.0], [-3.0, 4.0]])
                let res = Matrix([[1.0, 2.0], [3.0, 4.0]])
                expect(abs(m1)) == res
            }
            
            it("threshold") {
                let m1 = Matrix([[1.0, -2.0], [-3.0, 4.0]])
                let res = Matrix([[1.0, 0.0], [0.0, 4.0]])
                expect(thr(m1, 0.0)) == res
            }
        }
        
        describe("Matrix comparison") {
            it("equal") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let m2 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                expect(m1 == m2) == true
            }
            it("not equal") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let m2 = Matrix([[1.0, 4.0], [3.0, 2.0]])
                expect(m1 != m2) == true
            }
            it("greater/less than") {
                let m1 = Matrix([[11.0, 12.0], [13.0, 14.0]])
                let m2 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                expect(m1) > m2
                expect(m2) < m1
            }
            it("greater/less than or equal") {
                let m1 = Matrix([[11.0, 12.0], [13.0, 14.0]])
                let m2 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let m3 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                expect(m1) >= m2
                expect(m2) <= m1
                expect(m2) >= m3
                expect(m2) <= m3
            }
        }
        
        describe("Matrix subscript") {
            it("[i,j]") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                expect(m1[1, 1]) == 4.0
                m1[1, 0] = 10.0
                expect(m1[1, 0]) == 10.0
            }
            it("index") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                expect(m1[3]) == 4.0
                m1[2] = 10.0
                expect(m1[2]) == 10.0
                expect(m1[1, 0]) == 10.0
            }
            it("row") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                expect(m1[row: 1]) == [3.0, 4.0]
                m1[row: 0] = [10.0, 20.0]
                expect(m1[row: 0]) == [10.0, 20.0]
                expect(m1[0, 0]) == 10.0
                expect(m1[0, 1]) == 20.0
            }
            it("column") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                expect(m1[col: 1]) == [2.0, 4.0]
                m1[col: 0] = [10.0, 30.0]
                expect(m1[col: 0]) == [10.0, 30.0]
                expect(m1[0, 0]) == 10.0
                expect(m1[1, 0]) == 30.0
            }
        }

        describe("Matrix range-based subscript") {
            it("[i,j] -> Matrix") {
                let m1 = Matrix([[1.0, 2.0, 3.0],
                                 [4.0, 5.0, 6.0],
                                 [7.0, 8.0, 9.0]])
                let m2 = Matrix([[10.0, 11.0],
                                 [12.0, 13.0]])
                expect(m1[0, 1].flat) == [2.0, 3.0, 5.0, 6.0, 8.0, 9.0]
                m1[1, 0] = m2
                expect(m1[1..<3, 0...1].flat) == [10.0, 11.0, 12.0, 13.0]
            }
            it("closed") {
                let m1 = Matrix([[1.0, 2.0, 3.0],
                                 [4.0, 5.0, 6.0],
                                 [7.0, 8.0, 9.0]])
                let m2 = Matrix([[10.0, 11.0],
                                 [12.0, 13.0]])
                expect(m1[1...2, 0...1].flat) == [4.0, 5.0, 7.0, 8.0]
                m1[0...1, 1...2] = m2
                expect(m1.flat) == [1.0, 10.0, 11.0, 4.0, 12.0, 13.0, 7.0, 8.0, 9.0]
            }
            it("open") {
                let m1 = Matrix([[1.0, 2.0, 3.0],
                                 [4.0, 5.0, 6.0],
                                 [7.0, 8.0, 9.0]])
                let m2 = Matrix([[10.0, 11.0],
                                 [12.0, 13.0]])
                expect(m1[1..<3, 0..<2].flat) == [4.0, 5.0, 7.0, 8.0]
                m1[0..<2, 1..<3] = m2
                expect(m1.flat) == [1.0, 10.0, 11.0, 4.0, 12.0, 13.0, 7.0, 8.0, 9.0]
            }
            it("partial") {
                let m1 = Matrix([[1.0, 2.0, 3.0],
                                 [4.0, 5.0, 6.0],
                                 [7.0, 8.0, 9.0]])
                let m2 = Matrix([[10.0, 11.0],
                                 [12.0, 13.0]])
                expect(m1[1..., ..<2].flat) == [4.0, 5.0, 7.0, 8.0]
                m1[1..., 1...] = m2
                expect(m1.flat) == [1.0, 2.0, 3.0, 4.0, 10.0, 11.0, 7.0, 12.0, 13.0]
            }
            it("unbounded") {
                let m1 = Matrix([[1.0, 2.0, 3.0],
                                 [4.0, 5.0, 6.0],
                                 [7.0, 8.0, 9.0]])
                let m2 = Matrix([[10.0, 11.0, 12.0]])
                expect(m1[..., 2...2].flat) == [3.0, 6.0, 9.0]
                m1[1...1, ...] = m2
                expect(m1.flat) == [1.0, 2.0, 3.0, 10.0, 11.0, 12.0, 7.0, 8.0, 9.0]
            }
        }

        describe("Matrix map/reduce") {
            it("map") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let res = Matrix([[1.0, 4.0], [9.0, 16.0]])
                expect(map(m1, { $0 * $0 })) == res
            }
            it("map vec") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let res = Matrix([[1.0, 4.0], [9.0, 16.0]])
                expect(map(m1, square)) == res
            }
            it("reduce rows") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let res = [3.0, 7.0]
                expect(reduce(m1, sum)) == res
                expect(reduce(m1, sum, .Row)) == res
            }
            it("reduce cols") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let res = [4.0, 6.0]
                expect(reduce(m1, sum, .Column)) == res
            }
        }
        
        describe("Matrix power and exponential tests") {
            it("power") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let p = 3.0
                let res = Matrix([[1.0, 8.0], [27.0, 64.0]])
                expect(m1 .^ p) == res
            }
            it("square") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let res = Matrix([[1.0, 4.0], [9.0, 16.0]])
                expect(square(m1)) == res
                expect(m1 .^ 2.0) == res
            }
            it("sqrt") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let res = Matrix([[sqrt(1.0), sqrt(2.0)], [sqrt(3.0), sqrt(4.0)]])
                expect(sqrt(m1)) == res
                expect(m1 .^ 0.5) == res
            }
            it("exp") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let res = Matrix([[exp(1.0), exp(2.0)], [exp(3.0), exp(4.0)]])
                expect(exp(m1)) == res
            }
            it("log") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let res = Matrix([[log(1.0), log(2.0)], [log(3.0), log(4.0)]])
                expect(log(m1)) == res
            }
            it("log10") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let res = Matrix([[log10(1.0), log10(2.0)], [log10(3.0), log10(4.0)]])
                expect(log10(m1)) == res
            }
            it("log2") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let res = Matrix([[log2(1.0), log2(2.0)], [log2(3.0), log2(4.0)]])
                expect(log2(m1)) == res
            }
        }
        
        describe("Matrix trigonometric tests") {
            it("sin") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let res = Matrix([[sin(1.0), sin(2.0)], [sin(3.0), sin(4.0)]])
                expect(sin(m1)) == res
            }
            it("cos") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let res = Matrix([[cos(1.0), cos(2.0)], [cos(3.0), cos(4.0)]])
                expect(cos(m1)) == res
            }
            it("tan") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let res = Matrix([[tan(1.0), tan(2.0)], [tan(3.0), tan(4.0)]])
                expect(tan(m1)) == res
            }
        }
        
        describe("Matrix statistics tests") {
            it("max") {
                let m1 = Matrix([[1.0, 4.0], [3.0, 2.0]])
                let res1 = [4.0, 3.0]
                let res2 = [3.0, 4.0]
                expect(max(m1)).to(beCloseTo(res1))
                expect(max(m1, .Row)).to(beCloseTo(res1))
                expect(max(m1, .Column)).to(beCloseTo(res2))
            }
            it("maxi") {
                let m1 = Matrix([[1.0, 4.0], [3.0, 2.0]])
                let res1 = [1, 0]
                let res2 = [1, 0]
                expect(maxi(m1)) == res1
                expect(maxi(m1, .Row)) == res1
                expect(maxi(m1, .Column)) == res2
            }
            it("min") {
                let m1 = Matrix([[1.0, 4.0], [3.0, 2.0]])
                let res1 = [1.0, 2.0]
                let res2 = [1.0, 2.0]
                expect(min(m1)).to(beCloseTo(res1))
                expect(min(m1, .Row)).to(beCloseTo(res1))
                expect(min(m1, .Column)).to(beCloseTo(res2))
            }
            it("mini") {
                let m1 = Matrix([[1.0, 4.0], [3.0, 2.0]])
                let res1 = [0, 1]
                let res2 = [0, 1]
                expect(mini(m1)) == res1
                expect(mini(m1, .Row)) == res1
                expect(mini(m1, .Column)) == res2
            }
            it("mean") {
                let m1 = Matrix([[1.0, 4.0], [3.0, 2.0]])
                let res1 = [2.5, 2.5]
                let res2 = [2.0, 3.0]
                expect(mean(m1)).to(beCloseTo(res1))
                expect(mean(m1, .Row)).to(beCloseTo(res1))
                expect(mean(m1, .Column)).to(beCloseTo(res2))
            }
            it("std") {
                let m1 = Matrix([[1.0, 4.0], [3.0, 2.0]])
                let res1 = [sqrt(4.5 / 2.0), sqrt(0.5 / 2.0)]
                let res2 = [sqrt(2.0 / 2.0), sqrt(2.0 / 2.0)]
                expect(std(m1)).to(beCloseTo(res1))
                expect(std(m1, .Row)).to(beCloseTo(res1))
                expect(std(m1, .Column)).to(beCloseTo(res2))
            }
            it("normalize") {
                let m1 = Matrix([[1.0, 4.0], [3.0, 2.0]])
                let mr = mean(m1)
                let sr = std(m1)
                let mc = mean(m1, .Column)
                let sc = std(m1, .Column)
                let res1 = transpose((transpose(m1) - mr) ./ sr)
                let res2 = (m1 - mc) ./ sc
                expect(normalize(m1)) == res1
                expect(normalize(m1, .Row)) == res1
                expect(normalize(m1, .Column)) == res2
            }
            it("sum") {
                let m1 = Matrix([[1.0, 4.0], [3.0, 2.0]])
                let res1 = [5.0, 5.0]
                let res2 = [4.0, 6.0]
                expect(sum(m1)).to(beCloseTo(res1))
                expect(sum(m1, .Row)).to(beCloseTo(res1))
                expect(sum(m1, .Column)).to(beCloseTo(res2))
            }
            it("sumsq") {
                let m1 = Matrix([[1.0, 4.0], [3.0, 2.0]])
                let res1 = [17.0, 13.0]
                let res2 = [10.0, 20.0]
                expect(sumsq(m1)).to(beCloseTo(res1))
                expect(sumsq(m1, .Row)).to(beCloseTo(res1))
                expect(sumsq(m1, .Column)).to(beCloseTo(res2))
            }
        }
        
        describe("Matrix linear algebra tests") {
            it("trace") {
                let m1 = Matrix([[1.0, 0.0, 2.0],
                                 [-1.0, 5.0, 0.0],
                                 [0.0, 3.0, -9.0]])
                let res = -3.0
                expect(trace(m1)) == res
            }
            it("transpose") {
                let m1 = Matrix([[1.0, 4.0],
                                 [3.0, 2.0]])
                let res = Matrix([[1.0, 3.0],
                                  [4.0, 2.0]])
                expect(transpose(m1)) == res
                expect(m1′) == res
                expect(m1.T) == res
            }
            it("mtimes") {
                let m1 = Matrix([[1.0, 3.0, 5.0],
                                 [2.0, 4.0, 7.0]])
                let m2 = Matrix([[-5.0, 8.0, 11.0],
                                 [3.0, 9.0, 21.0],
                                 [4.0, 0.0, 8.0]])
                let res = Matrix([[24.0, 35.0, 114.0],
                                  [30.0, 52.0, 162.0]])
                expect(m1 * m2) == res
                expect(mtimes(m1, m2)) == res
            }
            it("mpower") {
                let m1 = Matrix([[1.0, 2.0],
                                 [3.0, 4.0]])
                let res1 = Matrix([[7.0, 10.0],
                                  [15.0, 22.0]])
                let res2 = inv(m1 * m1)
                let eye = Matrix([[1.0, 0.0],
                                  [0.0, 1.0]])
                expect(m1 ^ 1) == m1
                expect(m1 ^ 2) == res1
                expect(m1 ^ -2) == res2
                expect(m1 ^ 0) == eye
            }
            it("inverse") {
                let m1 = Matrix([[1.0, 0.0, 2.0],
                                 [-1.0, 5.0, 0.0],
                                 [0.0, 3.0, -9.0]])
                let res = Matrix([[0.88235294117647067, -0.11764705882352944, 0.19607843137254904],
                                  [0.17647058823529416, 0.17647058823529413, 0.03921568627450981],
                                  [0.058823529411764663, 0.058823529411764719, -0.098039215686274522]])
                expect(inv(m1)) == res
                expect(mpower(m1, -1)) == res
                expect(m1 ^ -1) == res
                let m2 = Matrix([[1.0, 0.0, 2.0], [-1.0, 5.0, 0.0]])
                
                #if !SWIFT_PACKAGE
                    expect { () -> Void in _ = inv(m2) }.to(throwAssertion())
                    expect { () -> Void in _ = inv(ones(3, 3)) }.to(throwAssertion())
                #endif
                
                expect(inv(m1) * m1) == eye(3, 3)
            }
            it("eigen") {
                let m1 = Matrix([[1.0000, 0.5000, 0.3333, 0.2500],
                                 [0.5000, 1.0000, 0.6667, 0.5000],
                                 [0.3333, 0.6667, 1.0000, 0.7500],
                                 [0.2500, 0.5000, 0.7500, 1.0000]])
                let e1 = eig(m1)
                expect(m1 * e1.V) == e1.V * e1.D
                let m2 = Matrix([[1.0, 0.0, 2.0],
                                 [-1.0, 5.0, 0.0]])
                
                #if !SWIFT_PACKAGE
                    expect { () -> Void in _ = eig(m2) }.to(throwAssertion())
                #endif
                let m3 = Matrix([[0, 1],
                                 [-2, -3]])
                let e2 = eig(m3)
                expect(m3 * e2.V) == e2.V * e2.D
                let v3 = Matrix([[-1.0, 0.0],
                                 [0.0, -2.0]])
                expect(e2.D) == v3

            }
            it("svd") {
                let m1 = Matrix([[1.0, 2.0],
                                 [3.0, 4.0],
                                 [5.0, 6.0],
                                 [7.0, 8.0]])
                let usv = svd(m1)
                expect(usv.U * usv.S * usv.V′) == m1
            }
            it("gsvd") {
                let m1 = Matrix([[1.0, 6.0, 11.0],
                                 [2.0, 7.0, 12.0],
                                 [3.0, 8.0, 13.0],
                                 [4.0, 9.0, 14.0],
                                 [5.0, 10.0, 15.0]])
                let m2 = Matrix([[8.0, 1.0, 6.0],
                                 [3.0, 5.0, 7.0],
                                 [4.0, 9.0, 2.0]])
                let m3 = Matrix([[0.5700,   -0.6457,   -0.4279],
                                 [-0.7455,   -0.3296,   -0.4375],
                                 [-0.1702,   -0.0135,   -0.4470],
                                 [0.2966,    0.3026,   -0.4566],
                                 [0.0490,    0.6187,   -0.4661]])
                let (U, _, _, _, _, _) = gsvd(m1, m2)
                expect(U == m3)
                
            }
            it("chol") {
                let m1 = Matrix([[1, 1, 1, 1, 1],
                                 [1, 2, 3, 4, 5],
                                 [1, 3, 6, 10, 15],
                                 [1, 4, 10, 20, 35],
                                 [1, 5, 15, 35, 70]])
                let u = chol(m1)
                expect(u′ * u) == m1
                let l = chol(m1, .Lower)
                expect(l * l′) == m1
            }
            it("det") {
                let m = Matrix([[1.44, -7.84, -4.39,  4.53],
                                [-9.96, -0.28, -3.24,  3.83],
                                [-7.55,  3.24,  6.27, -6.64],
                                [8.34,  8.09,  5.28,  2.06]])
                let d = det(m)
                
                expect(d).to(beCloseTo(-4044.7754))
            }
            it("lstsq") {
                // Setup
                let a1 = Matrix([[1.44, -7.84, -4.39,  4.53],
                                 [-9.96, -0.28, -3.24,  3.83],
                                 [-7.55,  3.24,  6.27, -6.64],
                                 [8.34,  8.09,  5.28,  2.06],
                                 [7.08,  2.52,  0.74, -2.47],
                                 [-5.45, -5.70, -1.19,  4.70]])
                let b1 = Matrix([[8.58,  9.35],
                                 [8.26, -4.43],
                                 [8.48, -0.70],
                                 [-5.28, -0.26],
                                 [5.72, -7.36],
                                 [8.93, -2.52]])
                let c2 = Matrix([[-0.4506, 0.2497],
                                 [-0.8491, -0.9020],
                                 [0.7066, 0.6323],
                                 [0.1288, 0.1351]])
                let d2 = Matrix([[195.3616, 107.05746]])
                
                // Run function
                let (c1, d1) = lstsqr(a1, b1)
                
                // Check solution matrix
                expect(c1.rows) == c2.rows
                expect(c1.cols) == c2.cols
                for i in 0..<c1.rows {
                    for j in 0..<c1.cols {
                        let e1: Double = c1[i, j]
                        let e2: Double = c2[i, j]
                        expect(e1).to(beCloseTo(e2, within:0.001))
                    }
                }
                
                // Check residue matrix
                expect(d1.rows) == d2.rows
                expect(d1.cols) == d2.cols
                for i in 0..<d1.rows {
                    for j in 0..<d1.cols {
                        let e1: Double = d1[i, j]
                        let e2: Double = d2[i, j]
                        expect(e1).to(beCloseTo(e2, within:0.001))
                    }
                }
            }
        }
        
        describe("Matrix concatenation") {
            it("horizontal scalar append") {
                let m1 = Matrix([[1.0, 2.0],
                                 [3.0, 4.0]])
                let v = 5.0
                let res = Matrix([[1.0, 2.0],
                                  [3.0, 4.0],
                                  [5.0, 5.0]])
                expect(m1 === v) == res
            }
            it("horizontal scalar prepend") {
                let m1 = Matrix([[1.0, 2.0],
                                 [3.0, 4.0]])
                let v = 5.0
                let res = Matrix([[5.0, 5.0],
                                  [1.0, 2.0],
                                  [3.0, 4.0]])
                expect(v === m1) == res
            }
            it("horizontal vector append") {
                let m1 = Matrix([[1.0, 2.0],
                                 [3.0, 4.0]])
                let v = [5.0, 6.0]
                let res = Matrix([[1.0, 2.0],
                                  [3.0, 4.0],
                                  [5.0, 6.0]])
                expect(m1 === v) == res
                expect(append(m1, rows: [v])) == res
                expect(append(m1, rows: Matrix([v]))) == res
            }
            it("horizontal vector prepend") {
                let m1 = Matrix([[1.0, 2.0],
                                 [3.0, 4.0]])
                let v = [5.0, 6.0]
                let res = Matrix([[5.0, 6.0],
                                  [1.0, 2.0],
                                  [3.0, 4.0]])
                expect(v === m1) == res
                expect(prepend(m1, rows: [v])) == res
                expect(prepend(m1, rows: Matrix([v]))) == res
            }
            it("horizontal matrix append") {
                let m1 = Matrix([[1.0, 2.0],
                                 [3.0, 4.0]])
                let m2 = Matrix([[5.0, 6.0],
                                [7.0, 8.0]])
                let res = Matrix([[1.0, 2.0],
                                  [3.0, 4.0],
                                  [5.0, 6.0],
                                  [7.0, 8.0]])
                expect(m1 === m2) == res
            }
            it("horizontal matrix prepend") {
                let m1 = Matrix([[1.0, 2.0],
                                 [3.0, 4.0]])
                let m2 = Matrix([[5.0, 6.0],
                                 [7.0, 8.0]])
                let res = Matrix([[5.0, 6.0],
                                  [7.0, 8.0],
                                  [1.0, 2.0],
                                  [3.0, 4.0]])
                expect(m2 === m1) == res
            }
            it("horizontal matrix insert") {
                let m1 = Matrix([[1.0, 2.0],
                                 [3.0, 4.0]])
                let m2 = Matrix([[5.0, 6.0],
                                 [7.0, 8.0]])
                let res = Matrix([[1.0, 2.0],
                                  [5.0, 6.0],
                                  [7.0, 8.0],
                                  [3.0, 4.0]])
                expect(insert(m1, rows: m2, at: 1)) == res
            }
            it("vertical scalar append") {
                let m1 = Matrix([[1.0, 2.0],
                                 [3.0, 4.0]])
                let v = 5.0
                let res = Matrix([[1.0, 2.0, 5.0],
                                  [3.0, 4.0, 5.0]])
                expect(m1 ||| v) == res
            }
            it("vertical scalar prepend") {
                let m1 = Matrix([[1.0, 2.0],
                                 [3.0, 4.0]])
                let v = 5.0
                let res = Matrix([[5.0, 1.0, 2.0],
                                  [5.0, 3.0, 4.0]])
                expect(v ||| m1) == res
            }
            it("vertical vector append") {
                let m1 = Matrix([[1.0, 2.0],
                                 [3.0, 4.0]])
                let v = [5.0, 6.0]
                let res = Matrix([[1.0, 2.0, 5.0],
                                  [3.0, 4.0, 6.0]])
                expect(m1 ||| v) == res
                expect(append(m1, cols: [v])) == res
                expect(append(m1, cols: Matrix(v))) == res
            }
            it("vertical vector prepend") {
                let m1 = Matrix([[1.0, 2.0],
                                 [3.0, 4.0]])
                let v = [5.0, 6.0]
                let res = Matrix([[5.0, 1.0, 2.0],
                                  [6.0, 3.0, 4.0]])
                expect(v ||| m1) == res
                expect(prepend(m1, cols: [v])) == res
                expect(prepend(m1, cols: Matrix(v))) == res
            }
            it("vertical matrix append") {
                let m1 = Matrix([[1.0, 2.0],
                                 [3.0, 4.0]])
                let m2 = Matrix([[5.0, 6.0],
                                 [7.0, 8.0]])
                let res = Matrix([[1.0, 2.0, 5.0, 6.0],
                                  [3.0, 4.0, 7.0, 8.0]])
                expect(m1 ||| m2) == res
            }
            it("vertical matrix prepend") {
                let m1 = Matrix([[1.0, 2.0],
                                 [3.0, 4.0]])
                let m2 = Matrix([[5.0, 6.0],
                                 [7.0, 8.0]])
                let res = Matrix([[5.0, 6.0, 1.0, 2.0],
                                  [7.0, 8.0, 3.0, 4.0]])
                expect(m2 ||| m1) == res
            }
            it("vertical matrix insert") {
                let m1 = Matrix([[1.0, 2.0],
                                 [3.0, 4.0]])
                let m2 = Matrix([[5.0, 6.0],
                                 [7.0, 8.0]])
                let res = Matrix([[1.0, 5.0, 6.0, 2.0],
                                  [3.0, 7.0, 8.0, 4.0]])
                expect(insert(m1, cols: m2, at: 1)) == res
            }
            it("vstack") {
                let m1 = Matrix([[1.0, 2.0, 3.0],
                                 [4.0, 5.0, 6.0]])
                let m2 = Matrix([[7.0, 8.0, 9.0],
                                 [10.0, 11.0, 12.0]])
                let res = Matrix([[1.0, 2.0, 3.0],
                                  [4.0, 5.0, 6.0],
                                  [7.0, 8.0, 9.0],
                                  [10.0, 11.0, 12.0]])
                expect(vstack([m1, m2])) == res
            }
            it("hstack") {
                let m1 = Matrix([[1.0, 2.0, 3.0],
                                 [4.0, 5.0, 6.0]])
                let m2 = Matrix([[7.0, 8.0, 9.0],
                                 [10.0, 11.0, 12.0]])
                let res = Matrix([[1.0, 2.0, 3.0, 7.0, 8.0, 9.0],
                                  [4.0, 5.0, 6.0, 10.0, 11.0, 12.0]])
                expect(hstack([m1, m2])) == res
            }
        }
        
        describe("matrix slicing") {
            it("basic tests") {
                let m1 = Matrix([[0,  1,  2,  3,  4],
                                 [5,  6,  7,  8,  9],
                                 [10, 11, 12, 13, 14],
                                 [15, 16, 17, 18, 19]])
                let res1 = Matrix([[0,  1,  2],
                                   [5,  6,  7],
                                   [10, 11, 12]])
                let res2 = Matrix([[12,  13,  14],
                                   [17,  18,  19]])
                let res3 = Matrix([[10, 11, 12, 13, 14],
                                   [5,  6,  7,  8,  9 ]])
                let res4 = Matrix([[2,  1],
                                  [7,  6],
                                  [12, 11],
                                  [17, 16]])
                let res5 = Matrix([[9, 7, 5],
                                   [4, 2, 0]])
                let res6 = Matrix([[18, 15],
                                   [8,  5]])
                expect(m1 ?? (.All, .All)) == m1
                expect(m1[(.All, .All)]) == m1
                expect(m1 ?? (.Take(3), .DropLast(2))) == res1
                expect(m1 ?? (.DropLast(1), .Take(3))) == res1
                expect(m1 ?? (.TakeLast(2), .TakeLast(3))) == res2
                expect(m1 ?? (.Drop(2), .Drop(2))) == res2
                expect(m1 ?? (.Pos([2, 1]), .All)) == res3
                expect(m1 ?? (.All, .Pos([2, 1]))) == res4
                expect(m1 ?? (.PosCyc([-7, 80]), .Range(4, -2, 0))) == res5
                expect(m1 ?? (.Range(3, -2, 0), .PosCyc([-7, 80]))) == res6
                #if !SWIFT_PACKAGE
                    expect { () -> Void in _ = m1 ?? (.Range(4, -2, 0), .All) }.to(throwAssertion())
                    expect { () -> Void in _ = m1 ?? (.Range(3, -2, -1), .All) }.to(throwAssertion())
                    expect { () -> Void in _ = m1 ?? (.All, .Range(5, -2, 0)) }.to(throwAssertion())
                    expect { () -> Void in _ = m1 ?? (.All, .Range(3, -2, -1)) }.to(throwAssertion())
                    expect { () -> Void in _ = m1 ?? (.Range(0, -2, 4), .All) }.to(throwAssertion())
                    expect { () -> Void in _ = m1 ?? (.Range(-1, -2, 3), .All) }.to(throwAssertion())
                    expect { () -> Void in _ = m1 ?? (.All, .Range(0, -2, 5)) }.to(throwAssertion())
                    expect { () -> Void in _ = m1 ?? (.All, .Range(-1, -2, 3)) }.to(throwAssertion())
                    expect { () -> Void in _ = m1 ?? (.Take(5), .All) }.to(throwAssertion())
                    expect { () -> Void in _ = m1 ?? (.Take(-1), .All) }.to(throwAssertion())
                    expect { () -> Void in _ = m1 ?? (.All, .Take(6)) }.to(throwAssertion())
                    expect { () -> Void in _ = m1 ?? (.All, .Take(-1)) }.to(throwAssertion())
                    expect { () -> Void in _ = m1 ?? (.Drop(5), .All) }.to(throwAssertion())
                    expect { () -> Void in _ = m1 ?? (.Drop(-1), .All) }.to(throwAssertion())
                    expect { () -> Void in _ = m1 ?? (.All, .Drop(6)) }.to(throwAssertion())
                    expect { () -> Void in _ = m1 ?? (.All, .Drop(-1)) }.to(throwAssertion())
                #endif
            }
        }
    }
}
