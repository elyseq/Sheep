// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sheep",
    platforms: [.macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Sheep",
            type: .dynamic,
            targets: ["Sheep"]),
    ],
    dependencies: [
        .package(url: "https://github.com/migueldeicaza/SwiftGodot", branch: "main") //changed from branch: "main" to from: "0.46"
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Sheep",
            dependencies: [
                "SwiftGodot",
            ],
            swiftSettings: [.unsafeFlags(["-suppress-warnings"])]
        ),
        .testTarget(
            name: "SheepTests",
            dependencies: ["Sheep"]
        ),
    ]
)

