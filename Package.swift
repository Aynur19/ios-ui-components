// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ios-ui-components",
    platforms: [],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "UIComponentsLibrary", targets: ["UIComponentsLibrary"]),
        .library(name: "SwiftExtensionsLibrary", targets: ["SwiftExtensionsLibrary"]),
    ],
    dependencies: [],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftExtensionsLibrary",
            dependencies: [],
            path: "SwiftExtensionsLibrary/Sources"
        ),
        .target(
            name: "UIComponentsLibrary",
            dependencies: ["SwiftExtensionsLibrary"],
            path: "UIComponentsLibrary/Sources/"
        ),
    ]
)
