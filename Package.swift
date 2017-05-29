// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "LanguageServerProtocol",
    targets: [
        Target(name: "LanguageServerProtocol"),
        Target(name: "JsonRpcProtocol", dependencies: ["LanguageServerProtocol"])
    ],
    dependencies: [
        .Package(url: "https://github.com/owensd/json-swift.git", majorVersion: 2, minor: 0)
    ]
)
