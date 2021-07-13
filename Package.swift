// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Ramp",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "Ramp", targets: ["Ramp"])
    ],
    dependencies: [
        .package(name: "Passbase", url: "https://github.com/passbase/passbase-sp.git", .exact("2.7.4")),
    ],
    targets: [
        .target(name: "Ramp", dependencies: ["Passbase"])
    ]
)
