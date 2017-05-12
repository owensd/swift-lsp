// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "LanguageServerProtocol",
    dependencies: [
        .Package(url: "https://github.com/owensd/json-swift.git", majorVersion: 1, minor: 2)
    ]
)
