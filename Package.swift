// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "scipio-cache-storage",
    products: [
        .library(
            name: "ScipioStorage",
            targets: ["ScipioStorage"]
        ),
    ],
    targets: [
        .target(
            name: "ScipioStorage"
        ),
    ]
)
