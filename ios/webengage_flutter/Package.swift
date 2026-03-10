// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "webengage-flutter",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        // If the plugin name contains "_", replace with "-" for the library name
        .library(name: "webengage-flutter", targets: ["webengage-flutter"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/ShubhamN123/WebEngageSPM.git",
            branch: "beta-test"
        )
    ],
    targets: [
        .target(
            // TODO: Update your target name.
            name: "webengage-flutter",
            dependencies: [
                 .product(name: "WebEngage", package: "WebEngage-iOS")
            ],
            resources: [
                // TODO: If your plugin requires a privacy manifest
                // (e.g. if it uses any required reason APIs), update the PrivacyInfo.xcprivacy file
                // to describe your plugin's privacy impact, and then uncomment this line.
                // For more information, see:
                // https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
                // .process("PrivacyInfo.xcprivacy"),

                // TODO: If you have other resources that need to be bundled with your plugin, refer to
                // the following instructions to add them:
                // https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package
            ],
            cSettings: [
                // TODO: Update your plugin name.
                .headerSearchPath("include/webengage-flutter")
            ]
        )
    ]
)
