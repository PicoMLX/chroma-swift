#!/bin/bash
set -euo pipefail
SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ROOT=$(cd -- "$SCRIPT_DIR/.." && pwd)
TARGET_PKG="$ROOT/Package.swift"
FRAMEWORK_DIR="$ROOT/../chroma/rust/swift_bindings/Chroma/chroma_swift_framework.xcframework"

if [[ ! -d "$FRAMEWORK_DIR" ]]; then
  echo "error: $FRAMEWORK_DIR not found. Run ./build_swift_package.sh first." >&2
  exit 1
fi

cat > "$TARGET_PKG" <<'EOF'
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
            path: "../chroma/rust/swift_bindings/Chroma/chroma_swift_framework.xcframework"
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
EOF
echo "Package.swift now points to the locally built XCFramework."
