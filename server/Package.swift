// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "server",
    platforms: [
          .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .executable(
            name: "server",
            targets: ["server"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Apodini/Apodini.git", .branch("refactor-notification-center")),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "server",
            dependencies: [
                .product(name: "Apodini", package: "Apodini"),
                .product(name: "ApodiniJobs", package: "Apodini"),
                .product(name: "ApodiniNotifications", package: "Apodini"),
                .product(name: "ApodiniDatabase", package: "Apodini"),
                .product(name: "ApodiniREST", package: "Apodini"),
                .product(name: "ApodiniOpenAPI", package: "Apodini"),
                .product(name: "AsyncHTTPClient", package: "async-http-client")
            ],
            resources: [
                .process("Certificates")
            ]
        ),
        .testTarget(
            name: "serverTests",
            dependencies: ["server"]),
    ]
)
