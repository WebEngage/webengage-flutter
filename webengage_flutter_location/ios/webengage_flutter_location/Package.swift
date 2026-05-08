// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "webengage_flutter_location",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "webengage-flutter-location", targets: ["webengage_flutter_location"])
    ],
    dependencies: [
        .package(url: "https://github.com/WebEngage/webengage-ios-sdk.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "webengage_flutter_location",
            dependencies: [
                .product(name: "WebEngageCore", package: "webengage-ios-sdk"),
                .product(name: "WebEngageLocation", package: "webengage-ios-sdk")
            ],
            resources: []
        )
    ]
)
