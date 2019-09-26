// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ModalView",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "ModalView",
            targets: ["ModalView"]),
    ],
    targets: [
        .target(
            name: "ModalView",
            dependencies: []),
        .testTarget(
            name: "ModalViewTests",
            dependencies: ["ModalView"]),
    ]
)
