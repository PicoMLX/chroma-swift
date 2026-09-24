// swift-tools-version: 6.2
import PackageDescription

// Core binding only: apps compute embeddings themselves and pass vectors in,
// so the package depends on nothing but Chroma's prebuilt XCFramework.
let package = Package(
    name: "chroma-swift",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "ChromaSwift",
            targets: ["Chroma"]
        )
    ],
    targets: [
        .target(
            name: "Chroma",
            dependencies: [
                "chroma_swiftFFI"
            ],
            path: "Chroma/Sources",
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ],
            linkerSettings: [
                .linkedFramework("SystemConfiguration")
            ]
        ),
        .binaryTarget(
            name: "chroma_swiftFFI",
            url: "https://github.com/chroma-core/chroma-swift/releases/download/1.0.2/chroma_swift_framework.xcframework.zip",
            checksum: "94c7f8044c6858104d7f48c774a50f3f5f83218a3cb9322852e067b546617823"
        ),
        .testTarget(
            name: "ChromaTests",
            dependencies: [
                "Chroma"
            ],
            path: "Tests/ChromaTests",
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        )
    ]
)
