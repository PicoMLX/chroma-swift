// swift-tools-version: 6.2
import PackageDescription

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
    dependencies: [
        .package(
            url: "https://github.com/ml-explore/mlx-swift-lm",
            from: "3.31.4"
        ),
        .package(
            url: "https://github.com/huggingface/swift-huggingface",
            from: "0.9.0"
        ),
        .package(
            url: "https://github.com/huggingface/swift-transformers",
            from: "1.3.0"
        )
    ],
    targets: [
        .target(
            name: "Chroma",
            dependencies: [
                "chroma_swiftFFI",
                .product(name: "MLXEmbedders", package: "mlx-swift-lm"),
                .product(name: "MLXLMCommon", package: "mlx-swift-lm"),
                .product(name: "MLXHuggingFace", package: "mlx-swift-lm"),
                .product(name: "HuggingFace", package: "swift-huggingface"),
                .product(name: "Tokenizers", package: "swift-transformers")
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
