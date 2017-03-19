# LASwift

[![CI Status](https://travis-ci.org/AlexanderTar/LASwift.svg?branch=master)](https://travis-ci.org/AlexanderTar/LASwift)
[![codecov](https://codecov.io/gh/AlexanderTar/LASwift/branch/master/graph/badge.svg)](https://codecov.io/gh/AlexanderTar/LASwift)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Documentation](https://img.shields.io/badge/LASwift-documentation-blue.svg)](https://alexandertar.github.io/LASwift-docs/index.html)
[![License](https://img.shields.io/cocoapods/l/LASwift.svg?style=flat)](https://raw.githubusercontent.com/AlexanderTar/LASwift/master/LICENSE)
[![Version](https://img.shields.io/cocoapods/v/LASwift.svg?style=flat)](http://cocoapods.org/pods/LASwift)
[![Platform](https://img.shields.io/cocoapods/p/LASwift.svg?style=flat)](http://cocoapods.org/pods/LASwift)

LASwift provides most of linear algebra operations on vectors and matrices
required to implement machine learning algorithms. Library syntax is inspired by
Matlab matrix manipulation and Haskell linear algebra library 'hmatrix'. LASwift is
using high-performant calculations provided by LAPACK, BLAS and vDSP through Apple
Accelerate framework.

## Currently supported

Following operations are fully supported for both vectors and matrices:

- Arithmetic operations (addition, substraction, multiplication, division, absolute value)
- Exponential functions (raise to power, exponent, logarithms)
- Trigonometric functions (sine, cosine, tangent)
- Statistics functions (max, min, mean value, standard deviation)

Linear algebra operations on matrices:

- Inversion
- Transposition
- Matrix power (integer values)
- Eigenvectors and eigenvalues
- Singular value decomposition

Following matrix manipulation operations are supported:

- Concatenation
- Slicing

## Requirements

- iOS 8.0+ / Mac OS X 10.9+ / tvOS 9.0+
- Xcode 8.0+
- Swift 3.0+

## Benchmarks

Refer to [linalg-benchmarks](https://github.com/Alexander-Ignatyev/linalg-benchmarks) project
regarding basic benchmarking of latest version of LASwift against most popular linear
algebra libraries (Haskell hmatrix, Python NumPy, Octave, Go gonum-matrix).

## Installation

#### CocoaPods

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```
Go to the directory of your Xcode project, and Create and Edit your *Podfile* and add _LASwift_:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

use_frameworks!
pod 'LASwift', '~> 0.1.0'
```

Install into your project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file):

``` bash
$ open MyProject.xcworkspace
```

You can now `import LASwift` framework into your files.

#### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate `LASwift` into your Xcode project using Carthage, specify it in your `Cartfile` file:

```ogdl
github "alexandertar/LASwift" >= 0.1.0
```

#### Swift Package Manager
You can use [The Swift Package Manager](https://swift.org/package-manager) to install `LASwift` by adding the proper description to your `Package.swift` file:
```swift
import PackageDescription

let package = Package(
name: "YOUR_PROJECT_NAME",
targets: [],
dependencies: [
.Package(url: "https://github.com/alexandertar/LASwift", versions: "0.1.0" ..< Version.max)
]
)
```

Note that the [Swift Package Manager](https://swift.org/package-manager) is still in early design and development, for more information checkout its [GitHub Page](https://github.com/apple/swift-package-manager).

## Contribution

Currently implemented functionality should be sufficient enough to implement machine learning
algorithms (as this was an initial purpose). However, if you find something missing or wish to add
extra features, feel free to submit pull-requests or create issues with proposals.

## Author

Alexander Taraymovich, taraymovich@me.com

## License

LASwift is available under the BSD-3-Clause license. See the LICENSE file for more info.
