// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "DWAlertController",
    platforms: [
        .iOS(.v9),
    ],
    products: [
        .library(
            name: "DWAlertController",
            targets: ["DWAlertController"]),
    ],
    targets: [
        .target(name: "DWAlertController",
                path: "DWAlertController"),
    ]
)
