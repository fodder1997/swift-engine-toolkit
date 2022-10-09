// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EngineToolkit",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "EngineToolkit",
            targets: ["EngineToolkit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Sajjon/K1.git", .upToNextMajor(from: "0.0.1")),
        .package(url: "https://github.com/pebble8888/ed25519swift.git", from: "1.2.7")
    ],
    targets: [
        .binaryTarget(
            name: "libTX",
            path: "Sources/libTX/libTX.xcframework"
        ),
        .target(
            name: "EngineToolkit",
            dependencies: ["libTX"]
        ),
        .testTarget(
            name: "EngineToolkitTests",
            dependencies: [
                "EngineToolkit",
                "K1",
                "ed25519swift"
            ],
            resources: [
                .copy("Resources"),
            ]
        ),
    ]
)
