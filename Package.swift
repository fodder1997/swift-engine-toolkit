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
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "RadixEngineToolkit",
            path: "Sources/RadixEngineToolkit/RadixEngineToolkit.xcframework"
        ),
        .target(
            name: "EngineToolkit",
            dependencies: ["RadixEngineToolkit"]
        ),
        .testTarget(
            name: "EngineToolkitTests",
            dependencies: ["EngineToolkit"]
        ),
    ]
)
