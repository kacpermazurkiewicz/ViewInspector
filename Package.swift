// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ViewInspector",
    platforms: [
        .macOS(.v10_15), .iOS(.v11), .tvOS(.v13)
    ],
    products: [
        .library(
            name: "ViewInspector", type: .dynamic, targets: ["ViewInspector"]),
    ],
    targets: [
        .target(
            name: "ViewInspector", dependencies: []),
        .testTarget(
            name: "ViewInspectorTests", dependencies: ["ViewInspector"]),
    ]
)
