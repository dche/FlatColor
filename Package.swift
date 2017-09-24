// swift-tools-version:4.0
//
// FlatColor - Color.swift
//
// Copyright (c) 2017 The FlatColor authors.
// Licensed under MIT License.

import PackageDescription

let package = Package(
    name: "FlatColor",
    products: [
        .library(
            name: "FlatColor",
            targets: ["FlatColor"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/dche/GLMath.git",
            .branch("master")
        )
    ],
    targets: [
        .target(
            name: "FlatColor",
            dependencies: ["GLMath"],
            path: "Sources"
        ),
        .testTarget(
            name: "FlatColorTests",
            dependencies: ["FlatColor"],
            path: "Tests/FlatColorTests"
        )
    ]
)
