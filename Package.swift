// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "Noul",
  platforms: [
    .iOS(.v13)
  ],
  products: [
    .library(name: "Noul", targets: ["Noul"]),
  ],
  targets: [
    .target(name: "Noul", path: "Sources"),
  ],
  swiftLanguageVersions: [
    .v5
  ]
)
