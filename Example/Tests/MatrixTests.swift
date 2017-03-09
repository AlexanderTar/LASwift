//
//  MatrixTests.swift
//  LASwift
//
//  Created by Alexander Taraymovich on 28/02/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import LASwift

class MatrixSpec: QuickSpec {
    override func spec() {
        describe("Matrix construction tests") {
            let count = 10
            
            let m1 = ones(count, count)
            
            it("ones matrix has correct dimensions") {
                expect(m1.rows) == count
                expect(m1.cols) == count
            }
            
            it("ones matrix all ones") {
                for (i, j) in zip(0..<count, 0..<count) {
                    expect(m1[i, j]).to(beCloseTo(1.0))
                }
            }
            
            let m2 = zeros(count, count)
            
            it("zeros matrix has correct dimensions") {
                expect(m2.rows) == count
                expect(m2.cols) == count
            }
            
            it("zeros matrix all zeros") {
                for (i, j) in zip(0..<count, 0..<count) {
                    expect(m2[i, j]).to(beCloseTo(0.0))
                }
            }
            
            let m3 = zeros(count, count)
            
            it("zeros vectors are equal") {
                expect(m3) == m2
            }
            
            it("zeros and ones vectors are not equal") {
                expect(m2) != m1
            }
            
            let m4 = eye(count, count)
            
            it("identity matrix has correct dimensions") {
                expect(m4.rows) == count
                expect(m4.cols) == count
            }
            
            it("identity matrix ones on diag") {
                for (i, j) in zip(0..<count, 0..<count) {
                    if i == j {
                        expect(m4[i, j]).to(beCloseTo(1.0))
                    } else {
                        expect(m4[i, j]).to(beCloseTo(0.0))
                    }
                }
            }
            
            let v1 = [1.0, 2.0, 3.0, 4.0, 5.0]
            let v2 = Matrix(v1)
            let m5 = diag(v1)
            let m6 = diag(v2)
            
            it("diag matrix has correct dimensions") {
                expect(m5.rows) == v1.count
                expect(m5.cols) == v1.count
                expect(m6.rows) == v1.count
                expect(m6.cols) == v1.count
            }
            
            it("diag matrix correct") {
                for (i, j) in zip(0..<v1.count, 0..<v1.count) {
                    if i == j {
                        expect(m5[i, j]).to(beCloseTo(v1[i]))
                        expect(m6[i, j]).to(beCloseTo(v1[i]))
                    } else {
                        expect(m5[i, j]).to(beCloseTo(0.0))
                        expect(m6[i, j]).to(beCloseTo(0.0))
                    }
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
                expect(square(m1)) == m1 .^ 2
            }
            it("sqrt") {
                let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
                let res = Matrix([[sqrt(1.0), sqrt(2.0)], [sqrt(3.0), sqrt(4.0)]])
                expect(sqrt(m1)) == res
                expect(sqrt(m1)) == m1 .^ 0.5
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
                let res = [3.0, 4.0]
                expect(max(m1)).to(beCloseTo(res))
            }
            it("min") {
                let m1 = Matrix([[1.0, 4.0], [3.0, 2.0]])
                let res = [1.0, 2.0]
                expect(min(m1)).to(beCloseTo(res))
            }
            it("mean") {
                let m1 = Matrix([[1.0, 4.0], [3.0, 2.0]])
                let res = [2.0, 3.0]
                expect(mean(m1)).to(beCloseTo(res))
            }
            it("std") {
                let m1 = Matrix([[1.0, 4.0], [3.0, 2.0]])
                let res = [sqrt(2.0 / 2.0), sqrt(2.0 / 2.0)]
                expect(std(m1)).to(beCloseTo(res))
            }
            it("normalize") {
                let m1 = Matrix([[1.0, 4.0], [3.0, 2.0]])
                let m = mean(m1)
                let s = std(m1)
                let res = (m1 - m) ./ s
                expect(normalize(m1)) == res
            }
        }
        
        describe("Matrix linear algebra tests") {
            it("trace") {
                let m1 = Matrix([[1.0, 0.0, 2.0],
                                 [-1.0, 5.0, 0.0],
                                 [0.0, 3.0, -9.0]])
                let res = [1.0, 5.0, -9.0]
                expect(trace(m1)) == res
            }
            it("transpose") {
                let m1 = Matrix([[1.0, 4.0],
                                 [3.0, 2.0]])
                let res = Matrix([[1.0, 3.0],
                                  [4.0, 2.0]])
                expect(transpose(m1)) == res
                expect(m1′) == res
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
                let res = Matrix([[7.0, 10.0],
                                  [15.0, 22.0]])
                expect(m1 ^ 2) == res
                expect(mpower(m1, 2)) == res
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
                expect { () -> Void in inv(m2) }.to(throwAssertion())
                expect { () -> Void in inv(ones(3, 3)) }.to(throwAssertion())
                expect(inv(m1) * m1) == eye(3, 3)
            }
            it("eigen") {
                let m1 = Matrix([[1.0000, 0.5000, 0.3333, 0.2500],
                                 [0.5000, 1.0000, 0.6667, 0.5000],
                                 [0.3333, 0.6667, 1.0000, 0.7500],
                                 [0.2500, 0.5000, 0.7500, 1.0000]])
                let e = eig(m1)
                expect(m1 * e.V) == e.V * e.D
                let m2 = Matrix([[1.0, 0.0, 2.0], [-1.0, 5.0, 0.0]])
                expect { () -> Void in eig(m2) }.to(throwAssertion())
            }
            it("svd") {
                let m1 = Matrix([[1.0, 2.0],
                                 [3.0, 4.0],
                                 [5.0, 6.0],
                                 [7.0, 8.0]])
                let usv = svd(m1)
                expect(usv.U * usv.S * usv.V′) == m1
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
            }
            it("horizontal vector prepend") {
                let m1 = Matrix([[1.0, 2.0],
                                 [3.0, 4.0]])
                let v = [5.0, 6.0]
                let res = Matrix([[5.0, 6.0],
                                  [1.0, 2.0],
                                  [3.0, 4.0]])
                expect(v === m1) == res
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
            }
            it("vertical vector prepend") {
                let m1 = Matrix([[1.0, 2.0],
                                 [3.0, 4.0]])
                let v = [5.0, 6.0]
                let res = Matrix([[5.0, 1.0, 2.0],
                                  [6.0, 3.0, 4.0]])
                expect(v ||| m1) == res
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
                let res2 = Matrix([[10, 11, 12, 13, 14],
                                   [5,  6,  7,  8,  9 ]])
                let res3 = Matrix([[9, 7, 5],
                                   [4, 2, 0]])
                expect(m1 ?? (.All, .All)) == m1
                expect(m1 ?? (.Take(3), .DropLast(2))) == res1
                expect(m1 ?? (.Pos([2, 1]), .All)) == res2
                expect(m1 ?? (.PosCyc([-7, 80]), .Range(4, -2, 0))) == res3
            }
        }
    }
}
