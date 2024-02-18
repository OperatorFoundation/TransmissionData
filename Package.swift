// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TransmissionData",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TransmissionData",
            targets: ["TransmissionData"]),
    ],
    dependencies: [
        .package(url: "https://github.com/OperatorFoundation/Straw", from: "1.0.1"),
        .package(url: "https://github.com/OperatorFoundation/SwiftHexTools", from: "1.2.6"),
        .package(url: "https://github.com/OperatorFoundation/Transmission", from: "1.2.11"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TransmissionData",
            dependencies: [
                "Straw",
                "SwiftHexTools",
                "Transmission",
            ]
        ),
        .testTarget(
            name: "TransmissionDataTests",
            dependencies: ["TransmissionData"]),
    ],
    swiftLanguageVersions: [.v5]
)
