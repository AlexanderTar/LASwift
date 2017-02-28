//
//  ArithmeticTests.swift
//  LASwift
//
//  Created by Alexander Taraymovich on 28/02/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import LASwift

class ArithmeticSpec: QuickSpec {
    override func spec() {
        describe("Arithmetic operations test") {
            let count = 10
            
            describe("basic operations") {
                let a: [Double] = rand(count)
                let b: [Double] = rand(count)
                
                
                it("addition") {
                    let c = add(a, b)
                    for i in 0..<count {
                        expect(c[i]).to(beCloseTo(a[i] + b[i]))
                    }
                }
                
                it("substraction") {
                    let c = sub(a, b)
                    for i in 0..<count {
                        expect(c[i]).to(beCloseTo(a[i] - b[i]))
                    }
                }
                
                it("multiplication") {
                    let c = mul(a, b)
                    for i in 0..<count {
                        expect(c[i]).to(beCloseTo(a[i] * b[i]))
                    }
                }
                
                it("division") {
                    let c = div(a, b)
                    for i in 0..<count {
                        expect(c[i]).to(beCloseTo(a[i] / b[i]))
                    }
                }
            }
            
            describe("vector operations") {
                let a: [Double] = rand(count)
                let b: [Double] = rand(count)
                
                it("dot product") {
                    let c = dot(a, b)
                    expect(c).to(beCloseTo(zip(a, b).map{ $0 * $1 }.reduce(0.0, +)))
                }
            }
            
            describe("scalar operations") {
                let a: [Double] = rand(count)
                let b: Double = Random.generate()
                
                it("addition") {
                    let c = add(a, b)
                    for i in 0..<count {
                        expect(c[i]).to(beCloseTo(a[i] + b))
                    }
                }
                
                it("substraction") {
                    let c = sub(a, b)
                    for i in 0..<count {
                        expect(c[i]).to(beCloseTo(a[i] - b))
                    }
                }
                
                it("multiplication") {
                    let c = mul(a, b)
                    for i in 0..<count {
                        expect(c[i]).to(beCloseTo(a[i] * b))
                    }
                }
                
                it("division") {
                    let c = div(a, b)
                    for i in 0..<count {
                        expect(c[i]).to(beCloseTo(a[i] / b))
                    }
                }
            }
            
            describe("unary operations") {
                let a: [Double] = rand(count)
                
                it("max") {
                    let c = max(a)
                    expect(c).to(beCloseTo(a.max()!))
                }
                
                it("min") {
                    let c = min(a)
                    expect(c).to(beCloseTo(a.min()!))
                }
                
                it("mean") {
                    let c = mean(a)
                    expect(c).to(beCloseTo(a.reduce(0.0, +) / Double(a.count)))
                }
                
                it("std") {
                    let c = std(a)
                    let v = sub(a, mean(a)).map{ $0 * $0 }.reduce(0.0, +) / Double(a.count)
                    expect(c).to(beCloseTo(v.squareRoot()))
                }
            }
            
            describe("unary vector operations") {
                let a: [Double] = rand(count)
                
                it("abs") {
                    let c = abs(a)
                    for i in 0..<count {
                        expect(c[i]).to(beCloseTo(abs(a[i])))
                    }
                }
                
                it("neg") {
                    let c = neg(a)
                    for i in 0..<count {
                        expect(c[i]).to(beCloseTo(-a[i]))
                    }
                }
                
                it("square") {
                    let c = square(a)
                    for i in 0..<count {
                        expect(c[i]).to(beCloseTo(a[i] * a[i]))
                    }
                }
                
                it("norm") {
                    let c = norm(a)
                    let m = mean(a)
                    let s = std(a)
                    for i in 0..<count {
                        expect(c[i]).to(beCloseTo((a[i] - m) / s))
                    }
                }
            }
            
            describe("vector functions") {
                let a: [Double] = rand(count)
                
                it("sqrt") {
                    let c = sqrt(a)
                    for i in 0..<count {
                        expect(c[i]).to(beCloseTo(a[i].squareRoot()))
                    }
                }
                
                it("exp") {
                    let c = exp(a)
                    for i in 0..<count {
                        expect(c[i]).to(beCloseTo(exp(a[i])))
                    }
                }
                
                it("log") {
                    let c = log(a)
                    for i in 0..<count {
                        expect(c[i]).to(beCloseTo(log(a[i])))
                    }
                }
                
                it("log10") {
                    let c = log10(a)
                    for i in 0..<count {
                        expect(c[i]).to(beCloseTo(log10(a[i])))
                    }
                }
                
                it("log2") {
                    let c = log2(a)
                    for i in 0..<count {
                        expect(c[i]).to(beCloseTo(log2(a[i])))
                    }
                }
                
                it("sin") {
                    let c = sin(a)
                    for i in 0..<count {
                        expect(c[i]).to(beCloseTo(sin(a[i])))
                    }
                }
                
                it("cos") {
                    let c = cos(a)
                    for i in 0..<count {
                        expect(c[i]).to(beCloseTo(cos(a[i])))
                    }
                }
                
                it("tan") {
                    let c = tan(a)
                    for i in 0..<count {
                        expect(c[i]).to(beCloseTo(tan(a[i])))
                    }
                }
                
                it("pow") {
                    let c = pow(a, 3.0)
                    for i in 0..<count {
                        expect(c[i]).to(beCloseTo(pow(a[i], 3.0)))
                    }
                }
            }
        }
    }
}
