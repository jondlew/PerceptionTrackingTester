// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "PerceptionTrackingTester",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "ParentFeature",
            targets: ["ParentFeature"]),
        
        .library(
            name: "ChildFeature",
            targets: ["ChildFeature"]),
        
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", branch: "observation-beta")
    ],
    targets: [
        .target(
            name: "ParentFeature",
            dependencies: [ "ChildFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        
        .target(
            name: "ChildFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        )
        
    ]
    
    
)
