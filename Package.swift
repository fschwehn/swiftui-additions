// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "melatonin",
    platforms: [
        .macOS(.v13),
        .iOS(.v15),
        .watchOS(.v8),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "melatonin-dynamic",
            type: .dynamic,
            targets: ["melatonin"]),
        .library(
            name: "melatonin-static",
            type: .static,
            targets: ["melatonin"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "melatonin",
            dependencies: []),
        .testTarget(
            name: "melatoninTests",
            dependencies: ["melatonin"]),
    ]
)
