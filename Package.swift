// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TaskTimer",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        .executableTarget(
            name: "TaskTimer",
            path: "Sources/TaskTimer"
        )
    ]
)
