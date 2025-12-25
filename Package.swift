// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

var plugins: [Target.PluginUsage] = []
if ProcessInfo.processInfo.environment["DISABLE_SWIFTLINT"] != "1" {
    plugins.append(.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"))
}

let package = Package(
    name: "xml-kit",
    platforms: [
       .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "XMLKit",
            targets: ["XMLKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.59.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "XMLKit",
            dependencies: [],
            plugins: plugins
        ),
        .testTarget(
            name: "XMLKitTests",
            dependencies: ["XMLKit"],
            plugins: plugins),
    ]
)
