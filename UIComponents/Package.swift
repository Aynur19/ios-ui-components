// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIComponents",
    platforms: [
        .iOS(.v16),
        .macOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UIComponents",
            targets: ["UIComponents"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "UIComponents",
            path: "Sources/UIComponents"//,
//            exclude: [],
//            resources: [],
//            swiftSettings: [
//                .define("PLATFORM_IOS") // если хочешь делать условные импорты
//            ]
        ),
        .target(
            name: "UIComponentsDemo",
            dependencies: ["UIComponents"],
            path: "Sources/UIComponentsDemo"//,
//            exclude: [],
//            resources: [],
//            swiftSettings: [
//                .define("PLATFORM_IOS") // если хочешь делать условные импорты
//            ]
        ),

    ]
)
