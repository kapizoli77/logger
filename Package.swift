// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Logger",
    platforms: [
        .iOS(.v13)
    ],

    products: [
        .library(
            name: "Logger",
            targets: [
                "Logger",
                "CrashlyticsOutput"
            ]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "10.16.0")),
    ],
    targets: [
        .target(
            name: "Logger",
            dependencies: [],
            path: "Sources/Logger"),
        .testTarget(
            name: "loggerTests",
            dependencies: ["Logger"]),
        .target(
            name: "CrashlyticsOutput",
            dependencies: [
                "Logger",
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk")
            ],
            path: "Sources/CrashlyticsOutput")
    ]
)

