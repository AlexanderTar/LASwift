# ``LASwift``

Linear algebra for Swift, built on Accelerate.

## Overview

LASwift provides a `Matrix` type and `Vector` (an array of `Double`) with
element-wise and linear algebra operations: arithmetic, exponents, trigonometry,
statistics, decompositions, least squares and more. The operations run on
Apple's Accelerate framework (vDSP, BLAS and LAPACK).

Add the package with Swift Package Manager:

```swift
.package(url: "https://github.com/AlexanderTar/LASwift.git", from: "1.0.0")
```

## Topics

### Vectors

- ``Vector``
- ``ones(_:)``
- ``rand(_:seed:)``
- ``randn(_:seed:)``
- ``dot(_:_:)``
- ``unique(_:)``
- ``isApproximatelyEqual(_:_:absoluteTolerance:relativeTolerance:)-(Double,_,_,_)``
- ``isApproximatelyEqual(_:_:absoluteTolerance:relativeTolerance:)-(Vector,_,_,_)``
- ``isApproximatelyEqual(_:_:absoluteTolerance:relativeTolerance:)-(Matrix,_,_,_)``

### Matrices

- ``Matrix``
- ``Dim``
- ``zeros(_:_:)``
- ``eye(_:_:)``
- ``diag(_:)-(Matrix)``
- ``diag(_:)-(Vector)``
- ``toRows(_:_:)``
- ``toCols(_:_:)``
- ``map(_:_:)-(_,(Double)->Double)``
- ``map(_:_:)-(_,(Vector)->Vector)``
- ``reduce(_:_:_:)``

### Arithmetic

- ``plus(_:_:)-(Matrix,Matrix)``
- ``plus(_:_:)-(Vector,Vector)``
- ``minus(_:_:)-(Matrix,Matrix)``
- ``minus(_:_:)-(Vector,Vector)``
- ``mtimes(_:_:)``
- ``rdivide(_:_:)-(Matrix,Matrix)``
- ``rdivide(_:_:)-(Vector,Vector)``
- ``ldivide(_:_:)-(Matrix,Matrix)``
- ``ldivide(_:_:)-(Vector,Vector)``
- ``abs(_:)->Matrix``
- ``abs(_:)->Vector``
- ``thr(_:_:)->Matrix``
- ``thr(_:_:)->Vector``

### Linear algebra

- ``inv(_:)``
- ``det(_:)``
- ``trace(_:)``
- ``transpose(_:)``
- ``mpower(_:_:)``
- ``eig(_:)``
- ``eigvals(_:)``
- ``svd(_:)``
- ``gsvd(_:_:)``
- ``chol(_:_:)``
- ``rank(_:tol:)``
- ``lstsqr(_:_:)``
- ``convolve(_:_:)``

### Statistics

- ``sum(_:)``
- ``sumsq(_:)``
- ``mean(_:)``
- ``min(_:)``
- ``max(_:)``
- ``std(_:normalization:)``
- ``Normalization``
- ``normalize(_:)``

### Trigonometry

- ``sin(_:)->Matrix``
- ``sin(_:)->Vector``
- ``cos(_:)->Matrix``
- ``cos(_:)->Vector``
- ``tan(_:)->Matrix``
- ``tan(_:)->Vector``
- ``asin(_:)->Matrix``
- ``asin(_:)->Vector``
- ``acos(_:)->Matrix``
- ``acos(_:)->Vector``
- ``atan(_:)->Matrix``
- ``atan(_:)->Vector``

### Exponents

- ``exp(_:)->Matrix``
- ``exp(_:)->Vector``
- ``log(_:)->Matrix``
- ``log(_:)->Vector``
- ``log2(_:)->Matrix``
- ``log2(_:)->Vector``
- ``log10(_:)->Matrix``
- ``log10(_:)->Vector``
- ``sqrt(_:)->Matrix``
- ``sqrt(_:)->Vector``
- ``square(_:)->Matrix``
- ``square(_:)->Vector``
- ``power(_:_:)->Matrix``
- ``power(_:_:)->Vector``

### Slicing and concatenation

- ``slice(_:_:)``
- ``Extractor``
- ``append(_:row:)-(_,Vector)``
- ``prepend(_:row:)-(_,Vector)``
- ``insert(_:row:at:)``
- ``hstack(_:)``

### Operators

- ``**(_:_:)``
- ``.**(_:_:)->Matrix``
- ``.**(_:_:)->Vector``
