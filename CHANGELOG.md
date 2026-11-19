# Changelog

## 1.0.0

1.0.0 is a breaking release. It makes `Matrix` a value type, fixes several results that
did not match their documentation, adds input checks, and moves the package to current
Apple platforms and Swift Package Manager only.

### Added

- `**` and `.**` power operators with exponentiation precedence (tighter than `*`).
- `eig` returns complex eigenvalues and right eigenvectors; new `eigvals`.
- `rank(_:tol:)` through the SVD, with NumPy's default tolerance.
- `unique` for vectors and for matrix rows or columns.
- `isApproximatelyEqual` for `Double`, `Vector` and `Matrix` (default absolute tolerance 1e-14, relative 0).
- `seed:` parameter on `rand` and `randn`.
- `std(_:normalization:)` with `.sample` (default) and `.population`.
- DocC documentation, published on GitHub Pages, and a Swift Package Index config.
- Contributing guide, code of conduct, security policy and issue and pull request templates.

### Changed

- `Matrix` is a `struct`: `Sendable`, `Hashable`, with exact `==`.
- `convolve` is true 2-D convolution, matching `conv2(A, K, 'same')`.
- `std` uses the sample deviation (N − 1) by default. `normalize` still divides by the population deviation.
- `thr` sets values below the threshold to 0, as documented.
- `gsvd` uses LAPACK's `dggsvd3`, and `U` is m × m as LAPACK defines it.
- Column statistics and column reads and writes use strided vDSP calls instead of transposing.
- Minimum platforms: macOS 13.3, iOS 16.4, tvOS 16.4, watchOS 9.4, visionOS 1.0. Swift 6 language mode, tools 6.2.
- Tests use Swift Testing. CI runs on GitHub Actions: build, tests, AddressSanitizer and coverage on macOS, and build-only jobs for iOS, tvOS, watchOS and visionOS.

### Deprecated

- `^` and `.^`. Use `**` and `.**`.

### Fixed

- `normalize(_:.Column)` returned the wrong shape.
- Slicing with ranges resolved them against the wrong axis, and `Take`/`Drop` at full size, zero steps and slice bounds were wrong.
- `tri` overflowed a heap buffer.
- `a - B` (scalar minus vector or matrix) and `det` no longer return `-0` for zero results.
- Many functions now check their inputs with `precondition` instead of reading or writing out of bounds.

### Removed

- The tolerance-based `==`, `<` and `>` overloads on `[Double]`, and `Comparable` on `Matrix`.
- CocoaPods, Carthage, jazzy and the generated Xcode project. Swift Package Manager is the only way to install.
- Quick and Nimble test dependencies.

### Migrating from 0.3

1. **Update your platforms.** Raise your deployment targets to macOS 13.3, iOS 16.4, tvOS 16.4,
   watchOS 9.4 or visionOS 1.0, and build with Xcode 26 or later.
2. **Install with Swift Package Manager.** CocoaPods and Carthage are gone:
   `.package(url: "https://github.com/AlexanderTar/LASwift.git", from: "1.0.0")`.
3. **`Matrix` is a value type.** Assigning a matrix copies it. Code that relied on two
   variables sharing one matrix, or on a function mutating its argument, must now return and
   assign the result. `Matrix(M)` still makes a copy and is no longer needed for that. `flat`
   is read-only from outside the module. Empty matrices cannot be built: dimensions must be positive.
4. **Equality is exact.** `==` on `Matrix` compares every element exactly, and `Matrix` is
   `Hashable`. The tolerance-based `==`, `<` and `>` on `[Double]` and the `Comparable`
   conformance of `Matrix` are gone. Replace `a == b` where you wanted a tolerance with
   `isApproximatelyEqual(a, b)`, and pass `absoluteTolerance:` or `relativeTolerance:` when the default
   is too tight.
5. **Powers.** `^` and `.^` still compile but warn. Switch to `**` and `.**`: they have
   exponentiation precedence, so `A * B ** 2` means `A * (B ** 2)`. With `^`, the same
   expression parsed as `(A * B) ^ 2`.
6. **`eig` returns four matrices.** It now returns `(V, D, Vi, Di)`: real and imaginary parts
   of the eigenvectors and of the eigenvalues, with right eigenvectors in the columns of `V`
   and `Vi`. For a matrix with real eigenvalues, `Vi` and `Di` are zero. Use `eigvals` when you
   only need the eigenvalues.
7. **`convolve` is a true convolution.** The kernel is flipped, as in `conv2(A, K, 'same')`.
   0.3 cross-correlated and zeroed the border elements; now the border is computed too. Flip
   your kernel if you relied on correlation. The kernel must have odd dimensions and be
   smaller than the matrix.
8. **`thr` zeroes below the threshold.** It used to set them to `t` (only `t = 0` gave
   the same result); `x.map { Swift.max($0, t) }` (for a matrix, `map(A) { Swift.max($0, t) }`)
   reproduces the old behaviour.
9. **`std` is the sample deviation.** It divides by N − 1 by default. Pass
   `normalization: .population` for the old result.
10. **`normalize(_:.Column)` keeps the matrix shape.**
11. **`rand` and `randn` take an optional `seed:`.** Pass a seed for reproducible values.
12. **New checks.** Mismatched dimensions, empty inputs, out-of-range indices and bad slice
    bounds now stop with a `precondition` failure instead of reading or writing out of bounds.
    Code that worked by accident may crash now.
13. **`gsvd`.** `U` is m × m, as LAPACK defines it.
14. **New functions.** `rank` and `unique` are available. If you defined your own, rename it or
    remove it.

## 0.3.2, 0.3.1, 0.3.0

The last releases before 1.0: CocoaPods, Carthage and Swift Package Manager support, with
Matrix as a class, tolerance-based comparison operators, `eig` returning `(V, D)`, and `std`
dividing by N. See the [release page](https://github.com/AlexanderTar/LASwift/releases) for details.
