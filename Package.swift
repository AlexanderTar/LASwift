// swift-tools-version:5.1
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
      .macOS(.v10_13), .iOS(.v12), .tvOS(.v12), .watchOS(.v6)
    ],
    products: [
        .library(name: "LASwift", targets: ["LASwift"])
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "5.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "10.0.0")
    ],
    targets: [
        .target(
            name: "LASwift", 
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "LASwiftTests",
            dependencies: ["LASwift", "Quick", "Nimble"],
            path: "Tests")
    ],
    swiftLanguageVersions: [.v5]
)
