// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pristine",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "Pristine",
            type: .static,
            targets: ["Pristine"]
        )
    ],
    targets: [
        .target(
            name: "Pristine"
        ),
        .testTarget(
            name: "PristineTests",
            dependencies: ["Pristine"]
        )
    ]
)
