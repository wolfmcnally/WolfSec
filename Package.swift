// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "WolfSec",
    platforms: [
        .iOS(.v9), .macOS(.v10_13), .tvOS(.v11)
    ],
    products: [
        .library(
            name: "WolfSec",
            type: .dynamic,
            targets: ["WolfSec"]),
        ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/WolfPipe", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfFoundation", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "WolfSec",
            dependencies: [
                "WolfPipe",
                "WolfFoundation"
        ])
        ]
)
