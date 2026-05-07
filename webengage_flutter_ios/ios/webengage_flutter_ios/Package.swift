// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "webengage_flutter_ios",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "webengage-flutter-ios", targets: ["webengage_flutter_ios"])
    ],
    dependencies: [
        .package(url: "https://github.com/WebEngage/webengage-ios-sdk.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "webengage_flutter_ios",
            dependencies: [
                .product(name: "WebEngageCore", package: "webengage-ios-sdk")
            ],
            cSettings: [
                .headerSearchPath("include/webengage_flutter_ios")
            ]
        )
    ]
)
