// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Ramp",
    defaultLocalization: "en",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "Ramp", targets: ["Ramp"])
    ],
    targets: [
        .target(name: "Ramp"),
        .testTarget(name: "RampTests", dependencies: ["Ramp"])
    ]
)
