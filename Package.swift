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
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "5.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "10.0.0")
    ],
    targets: [
        // C shim over Accelerate's new LAPACK interface; see its header for why it is a C target.
        .target(
            name: "CLASwiftLAPACK",
            cSettings: [.define("ACCELERATE_NEW_LAPACK"), .define("ACCELERATE_LAPACK_ILP64")]),
        .target(
            name: "LASwift",
            dependencies: ["CLASwiftLAPACK"]),
        .testTarget(
            name: "LASwiftTests",
            dependencies: ["LASwift", "Quick", "Nimble"])
    ],
    swiftLanguageModes: [.v6]
)
