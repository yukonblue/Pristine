// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pristine",
    platforms: [.iOS(.v16), .macOS(.v14)],
    products: [
        .library(
            name: "Pristine",
            type: .static,
            targets: ["Pristine"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-perception.git", from: "1.3.5")
    ],
    targets: [
        .target(
            name: "Pristine",
            dependencies: [
                .product(name: "Perception", package: "swift-perception"),
            ]
        ),
        .testTarget(
            name: "PristineTests",
            dependencies: ["Pristine"]
        )
    ]
)
