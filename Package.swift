// swift-tools-version: 6.2
// Package.swift
//
// Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
// All rights reserved.
//
// This software may be modified and distributed under the terms
// of the BSD license. See the LICENSE file for details.
import PackageDescription

let package = Package(
    name: "LASwift",
    platforms: [
      .macOS("13.3"), .iOS("16.4"), .tvOS("16.4"), .watchOS("9.4"), .visionOS("1.0")
    ],
    products: [
        .library(name: "LASwift", targets: ["LASwift"])
    ],
    targets: [
        // C shim over Accelerate's new LAPACK interface; see its header for why it is a C target.
        .target(
            name: "CLASwiftLAPACK",
            cSettings: [.define("ACCELERATE_NEW_LAPACK"), .define("ACCELERATE_LAPACK_ILP64")],
            // Off Apple platforms the shim calls the system LAPACK/BLAS (e.g. Ubuntu's
            // liblapack-dev + libopenblas-dev) through their standard LP64 Fortran interface.
            linkerSettings: [
                .linkedLibrary("lapack", .when(platforms: [.linux])),
                .linkedLibrary("blas", .when(platforms: [.linux]))
            ]),
        .target(
            name: "LASwift",
            dependencies: ["CLASwiftLAPACK"]),
        .testTarget(
            name: "LASwiftTests",
            dependencies: ["LASwift"])
    ],
    swiftLanguageModes: [.v6]
)
