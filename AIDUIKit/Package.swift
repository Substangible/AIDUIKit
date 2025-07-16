// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AIDUIKit",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9)],
    products: [
        .library(
            name: "AIDUIKit",
            targets: ["AIDUIKit"]
        ),
    ],
    dependencies: [
        // No external dependencies - includes custom AnyCodable implementation
    ],
    targets: [
        .target(
            name: "AIDUIKit",
            dependencies: [],
            path: "Sources/AIDUIKit"
        ),
        .testTarget(
            name: "AIDUIKitTests",
            dependencies: ["AIDUIKit"],
            path: "Tests/AIDUIKitTests"
        ),
    ]
) 