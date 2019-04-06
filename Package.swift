// swift-tools-version:4.0
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
    products: [
        .library(name: "LASwift", targets: ["LASwift"])
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "2.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "8.0.1")
    ],
    targets: [
        .target(
            name: "LASwift", 
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "LASwiftTests",
            dependencies: ["LASwift", "Quick", "Nimble"],
            path: "Example/Tests")
    ]
)
